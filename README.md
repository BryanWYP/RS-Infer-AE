# RS-Infer Artifact Evaluation

This repository contains the Artifact Evaluation (AE) instructions and experiment wrappers for the paper:

> **RS-Infer: A Fast and Secure LLM Inference System for Mobile Devices with Recallable Resource Isolation**

The artifact evaluates the main performance results reported in the paper. The experiments use a dedicated host connected to the reference RK3588 development board. This public repository mirrors the instructions and wrappers available on that host; the complete source tree, datasets, models, toolchains, and board are provided through the remote evaluation environment.

Thank you for taking the time to evaluate this artifact. We welcome questions and reports of unexpected behavior through the HotCRP artifact-evaluation discussion.

## Requesting Access

Access to the evaluation machine is provisioned with an SSH public key. Please use the following procedure:

1. Generate a dedicated SSH key pair if needed:

   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/rsinfer_ae -C "rsinfer-ae"
   ```

2. Display the public key:

   ```bash
   cat ~/.ssh/rsinfer_ae.pub
   ```

3. Post the complete public-key line in a comment on the paper's HotCRP artifact-evaluation discussion. Please submit only the `.pub` content. Never post or send the private key.

4. The artifact authors will install the key and reply through HotCRP with the assigned SSH username and host address.

5. Connect to the machine using the supplied values:

   ```bash
   ssh -i ~/.ssh/rsinfer_ae <ae-user>@<ae-host>
   ```

If access fails, please report the exact SSH error in HotCRP. Do not post private credentials or private-key material.

## Evaluation Workspace

After logging in, the prepared workspace is located at:

```text
/home/santongding/CodeSpace/RecaLLMem-new
```

The relevant directories are:

| Path | Purpose |
| --- | --- |
| `art-eval/` | Reviewer-facing wrappers and this guide |
| `RecaLLMem/` | Inference engine, benchmark code, and build/test scripts |
| `linux/` | Linux kernel source |
| `optee_os/` | OP-TEE OS source |
| `build/` | Platform build configuration |
| `test-ae/` | Raw logs and generated summaries |

The board address is maintained by the prepared environment in `RecaLLMem/find-ip.stamp`. Reviewers do not need to configure the board address manually.

## Quick Start

Each supported figure has a one-command wrapper. Run the preflight check first; it verifies the required branches and the underlying test entry without compiling or using the board.

```bash
cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_1
./run.sh --check
```

Run the complete experiment from the same directory:

```bash
./run.sh
```

Replace `figure_1` with the desired figure directory. The wrapper verifies the required repository branches, switches branches only when the affected repositories are clean, and then starts the figure-specific end-to-end test. It never discards local changes.

Valid existing results are reused. If a terminal disconnects or a test is interrupted, reconnect to the machine and run the same command again. Completed cases will be skipped and incomplete cases will be retried by the underlying test.

## Supported Experiments

The estimates below are for a clean run on the reference board. Kernel rebuilds, storage state, board load, and retries may change the total time.

| Figure | Evaluation | Approximate time | Run directory |
| --- | --- | --- | --- |
| Figure 1 | CMA and MMAP allocation latency under varying allocation sizes and background memory pressure | 20-40 minutes | `art-eval/figure_1` |
| Figure 2 | Llama3.1 8B TTFT breakdown across allocation, loading, decryption, computation, and other time | 5-10 minutes | `art-eval/figure_2` |
| Figure 5 | TTFT across inference baselines, models, and prompt lengths | 1-2 hours | `art-eval/figure_5` |
| Figure 6 | Decode throughput and RS-Infer overhead across four models | 30-60 minutes | `art-eval/figure_6` |
| Figure 7 | TTFT sensitivity to background memory pressure | 2-4 hours | `art-eval/figure_7` |
| Figure 8 | Cached two-model combinations and dataset-weighted TTFT | 2-4 hours | `art-eval/figure_8` |
| Figure 9 | End-to-end latency of multi-model application workflows | 1-3 hours | `art-eval/figure_9` |
| Figure 10 | Normal-world application performance and secure-inference TTFT under cache policies | 2-4 hours | `art-eval/figure_10` |
| Figure 11 | Incremental TTFT benefit of the RS-Infer optimizations | 30-60 minutes | `art-eval/figure_11` |

Figures 1, 2, 5-9, and 11 use:

| Repository | Branch |
| --- | --- |
| `RecaLLMem` | `art-eval-pre` |
| `linux` | `art-eval-pre` |

Figure 10 uses:

| Repository | Branch |
| --- | --- |
| `RecaLLMem` | `art-eval` |
| `linux` | `sysbench-novirt` |
| `build` | `sysbench-novirt` |

Branch selection is handled by each wrapper. Manual branch changes are not required.

## Results

Results are written under:

```text
/home/santongding/CodeSpace/RecaLLMem-new/test-ae/figure_N
```

Depending on the figure, the result directory contains:

- raw inference or workload logs;
- build and orchestration logs;
- per-case environment metadata;
- `summary.csv` and/or figure-specific CSV files;
- `summary.md` for direct inspection.

Please retain the raw logs when checking a result against the paper. The summary scripts reject incomplete records instead of silently filling missing values.

## Operational Notes

- Run only one figure at a time. The experiments share one development board and may rebuild or flash its kernel.
- Do not start unrelated workloads on the host or board during measurement.
- Do not modify the project source or benchmark configuration unless requested during artifact discussion.
- A branch switch is refused when a repository contains local changes. This protects previous results and reviewer modifications from accidental loss.
- Long-running experiments are best executed inside `tmux` or another persistent terminal session.
- The first run is the slowest because it may rebuild the kernel and inference engine. Resumed runs reuse valid records.

Example persistent session:

```bash
tmux new -s rsinfer-ae
cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_10
./run.sh
```

Detach with `Ctrl-b d` and reconnect with:

```bash
tmux attach -t rsinfer-ae
```

## Support

Please use the HotCRP artifact-evaluation discussion for questions, access problems, unexpected failures, or discrepancies with the paper. Include the figure number, the command that was run, and the relevant error or log path. We will respond there so that the evaluation discussion remains auditable and available to the AE reviewers.
