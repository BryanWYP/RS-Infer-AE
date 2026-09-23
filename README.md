# RS-Infer Artifact Evaluation

This repository contains the Artifact Evaluation (AE) instructions and experiment wrappers for the paper:

> **RS-Infer: A Fast and Secure LLM Inference System for Mobile Devices with Recallable Resource Isolation**

The artifact evaluates the main performance results reported in the paper. The experiments use a dedicated host connected to the reference RK3588 development board. This public repository mirrors the instructions and wrappers available through the remote evaluation environment.

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

## Evaluation Scope and Privacy

The evaluation machine is a shared personal system prepared specifically for this AE. Please use only the commands documented in this repository.

Please do not inspect, modify, copy, move, or delete host configuration, files, repositories, credentials, services, or data outside the designated AE directories. Content outside the AE workspace and generated result directory is private. The provided wrappers may internally access prepared dependencies; reviewers should not access or modify those dependencies manually. Thank you for respecting this boundary.

The evaluation has one development board. All experiments must run serially. Run exactly one AE command at a time across all terminal and SSH sessions, and wait for it to finish before starting another experiment. Do not launch experiments in parallel.

## Evaluation Workspace

Run all commands from the prepared reviewer directory:

```text
/home/santongding/CodeSpace/RecaLLMem-new/art-eval
```

Environment preparation, execution, retries, and result collection are handled by the wrappers. No manual configuration is required.

## Running the Artifact

The following commands are the supported one-command entry points. Expected durations are estimates for a clean run. A resumed run may be shorter because valid results are reused.

| Artifact | Expected duration | One-command invocation |
| --- | ---: | --- |
| Table 1 | 30-60 minutes | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/table_1 && ./run.sh` |
| Figure 5 | 1-2 hours | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_5 && ./run.sh` |
| Figure 6 | 30-60 minutes | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_6 && ./run.sh` |
| Figure 7 | 2-4 hours | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_7 && ./run.sh` |
| Figure 8 | 2-4 hours | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_8 && ./run.sh` |
| Figure 9 | 1-3 hours | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_9 && ./run.sh` |
| Figure 10 | 2-4 hours | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_10 && ./run.sh` |
| Figure 11 | 30-60 minutes | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/figure_11 && ./run.sh` |
| SPEC CPU 2017 | 16-20 hours | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/spec_cpu && ./run.sh` |
| SQLite interference | 20-40 minutes | `cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/sqlite_interference && ./run.sh` |

To check an entry point without starting an experiment, append `--check` to the same command. For example:

```bash
cd /home/santongding/CodeSpace/RecaLLMem-new/art-eval/table_1 && ./run.sh --check
```

If a terminal disconnects or a run is interrupted, reconnect and invoke the same command again. Valid completed cases are reused, while incomplete cases are retried.

## Results

Results are written under:

```text
/home/santongding/CodeSpace/RecaLLMem-new/test-ae/<artifact>
```

Depending on the artifact, the result directory contains:

- raw inference or workload logs;
- build and orchestration logs;
- per-case environment metadata;
- `summary.csv` and/or figure-specific CSV files;
- `summary.md` for direct inspection.

Please retain the raw logs when checking a result against the paper. The summary scripts reject incomplete records instead of silently filling missing values.

## Operational Notes

- Run only one AE experiment at a time. This requirement applies across all users, terminals, SSH sessions, and `tmux` sessions because every experiment shares the same development board.
- Wait for the active command to finish completely before starting another command. Do not parallelize experiments.
- Do not start unrelated workloads on the host or board during measurement.
- Do not manually inspect or modify files, configuration, repositories, services, or data outside the designated AE and result directories. Other content on the machine is private.
- Do not modify artifact source or benchmark configuration unless explicitly requested through the HotCRP artifact discussion.
- Long-running experiments are best executed inside `tmux` or another persistent terminal session.
- The first run may take longer while the prepared environment is initialized. Resumed runs reuse valid records.

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

Please use the HotCRP artifact-evaluation discussion for questions, access problems, unexpected failures, or discrepancies with the paper. Include the artifact name, the command that was run, and the relevant error or log path. We will respond there so that the evaluation discussion remains auditable and available to the AE reviewers.
