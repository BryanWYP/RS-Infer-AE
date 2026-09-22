#!/usr/bin/env bash

set -euo pipefail

AE_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WORKSPACE_ROOT=$(cd "${AE_ROOT}/.." && pwd)
RECALLMEM_DIR="${WORKSPACE_ROOT}/RecaLLMem"
LINUX_DIR="${WORKSPACE_ROOT}/linux"
BUILD_DIR="${WORKSPACE_ROOT}/build"

check_repo() {
    local repo_dir=$1
    local expected_branch=$2
    local repo_name=$3
    local current_branch

    if ! git -C "${repo_dir}" rev-parse --git-dir >/dev/null 2>&1; then
        echo "ERROR: ${repo_name} is not a Git repository: ${repo_dir}" >&2
        return 1
    fi
    if ! git -C "${repo_dir}" show-ref --verify --quiet "refs/heads/${expected_branch}"; then
        echo "ERROR: ${repo_name} branch '${expected_branch}' is not available." >&2
        return 1
    fi

    current_branch=$(git -C "${repo_dir}" branch --show-current)
    if [[ "${current_branch}" != "${expected_branch}" ]]; then
        if [[ -n $(git -C "${repo_dir}" status --porcelain) ]]; then
            echo "ERROR: Cannot switch ${repo_name} from '${current_branch:-detached}' to '${expected_branch}'." >&2
            echo "The repository has local changes. Preserve or remove them, then run this script again." >&2
            git -C "${repo_dir}" status --short >&2
            return 1
        fi
    fi
}

prepare_repo() {
    local repo_dir=$1
    local expected_branch=$2
    local repo_name=$3
    local current_branch

    current_branch=$(git -C "${repo_dir}" branch --show-current)
    if [[ "${current_branch}" != "${expected_branch}" ]]; then
        echo "Switching ${repo_name}: ${current_branch:-detached} -> ${expected_branch}"
        git -C "${repo_dir}" switch "${expected_branch}"
    fi

    current_branch=$(git -C "${repo_dir}" branch --show-current)
    if [[ "${current_branch}" != "${expected_branch}" ]]; then
        echo "ERROR: ${repo_name} branch verification failed." >&2
        return 1
    fi
    echo "Verified ${repo_name}: ${expected_branch} ($(git -C "${repo_dir}" rev-parse --short HEAD))"
}

run_figure() {
    local figure=$1
    local recallmem_branch=$2
    local linux_branch=$3
    shift 3

    if [[ $# -gt 1 || ($# -eq 1 && $1 != "--check") ]]; then
        echo "Usage: ./run.sh [--check]" >&2
        return 2
    fi

    check_repo "${RECALLMEM_DIR}" "${recallmem_branch}" "RecaLLMem"
    check_repo "${LINUX_DIR}" "${linux_branch}" "Linux"
    prepare_repo "${RECALLMEM_DIR}" "${recallmem_branch}" "RecaLLMem"
    prepare_repo "${LINUX_DIR}" "${linux_branch}" "Linux"

    local entry="${RECALLMEM_DIR}/art-eval/${figure}/test_all.py"
    if [[ ! -x "${entry}" ]]; then
        echo "ERROR: Test entry is missing or not executable: ${entry}" >&2
        return 1
    fi

    echo "Verified test entry: ${entry}"
    echo "Result directory: ${WORKSPACE_ROOT}/test-ae/${figure}"
    if [[ $# -eq 1 ]]; then
        echo "Preflight check completed."
        return 0
    fi

    cd "${RECALLMEM_DIR}"
    exec "${entry}"
}
