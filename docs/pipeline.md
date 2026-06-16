# Benchmark architecture

## Infrastructure

What `terraform apply` provisions per matrix job, and tears down when it finishes.

```mermaid
flowchart TB
    runner["GitHub Actions runner<br/>Terraform + SSH provisioning"]

    subgraph AWS["AWS, region us-east-2, AZ us-east-2a"]
        igw(["Internet gateway"])
        subgraph VPC["VPC 172.16.0.0/16, default security group"]
            sg["Security group ingress<br/>22 from 0.0.0.0/0<br/>5672 / 1883 / 15672 from VPC"]
            subgraph SUBNET["Public subnet 172.16.10.0/24"]
                broker["Broker EC2<br/>Ubuntu 24.04, arm64 or amd64<br/>Crystal + LavinMQ broker"]
                lg["Load generator EC2<br/>Ubuntu 24.04<br/>lavinmqperf + emqtt-bench"]
            end
        end
    end

    runner -->|"SSH 22: install, run, scp results"| igw
    igw --> broker
    igw --> lg
    lg -->|"AMQP 5672 / MQTT 1883 over private IP"| broker
```

## Workflow

From release trigger to published results at `benchmark.lavinmq.com`.

```mermaid
flowchart TD
    cron["Hourly cron<br/>poll-lavinmq-releases.yml"]
    manual["Manual dispatch<br/>UI / gh workflow run"]
    cron -->|"diff packagecloud index<br/>vs. handled versions"| newver{"New stable<br/>or RC?"}
    newver -->|yes| dispatch["gh workflow run benchmark.yml"]
    manual --> dispatch
    dispatch --> orch["benchmark.yml orchestrator<br/>concurrency per version"]

    orch --> lset
    orch --> tset
    orch --> mset

    subgraph LAT["Latency"]
        direction LR
        lset["benchmark-latency.yml<br/>setup, build matrix"] --> lrun["Matrix run<br/>11 instance types"]
    end
    subgraph THR["Throughput"]
        direction LR
        tset["benchmark-throughput.yml<br/>setup, build matrix"] --> trun["Matrix run<br/>11 instance types"]
    end
    subgraph MQ["MQTT throughput"]
        direction LR
        mset["benchmark-mqtt-throughput.yml<br/>setup, build matrix"] --> mrun["Matrix run<br/>11 instance types"]
    end

    lrun -.->|"per instance type"| JOB
    trun -.-> JOB
    mrun -.-> JOB

    subgraph JOB["Each matrix job, in parallel, fail-fast off"]
        direction LR
        j1["terraform apply<br/>provision stack"] --> j2["many load-test runs<br/>lavinmqperf for AMQP,<br/>emqtt-bench for MQTT<br/>sizes x rates x N runs"]
        j2 --> j3["scp results,<br/>upload artifact"] --> j4["terraform destroy"]
    end

    JOB --> agg["Aggregate job<br/>download artifacts, median MD + JSON"]
    agg --> pr["Open / update PR<br/>results/v{version}, draft on failure"]
    pr -->|"review + merge"| main["main branch<br/>results/**"]
    main --> pages["pages.yml<br/>build_latest.py + build_data.py"]
    pages --> bench["benchmark.lavinmq.com<br/>GitHub Pages"]
    bench -->|"HTTPS"| site["lavinmq.com/benchmark<br/>charts UI"]
```
