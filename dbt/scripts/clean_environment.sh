#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# dbt
find ${script_dir}/.. -name 'dbt_packages' -exec rm -fr {} +
find ${script_dir}/.. -name 'logs' -exec rm -fr {} +
find ${script_dir}/.. -name 'target' -exec rm -fr {} +

# logs
find ${script_dir}/.. -name 'logs' -exec rm -fr {} +