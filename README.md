# Installation Script for Riveter NLP on Savio

This document describes the steps and decisions made in creating the installation script for Riveter NLP. It also explains the configurations specific to the Berkeley Research Computing (BRC) Savio environment.

## Key Configurations and Decisions

### Python Version
The default Python module available on Savio (3.10 or 3.11) is used to ensure compatibility with the environment. The script does not explicitly set the Python version in the Conda environment creation step, as this is handled by the Savio module configuration.

### Conda Environment Management
- **Clean Install:** The script removes any existing environment with the name `riveter_env` before creating a new one. This ensures a clean slate for every installation.
- **Channel Configuration:** The `conda-forge` channel is added for accessing packages not available in the default channel.

### Dependency Installation
- **Mamba Utilization:** If `mamba` is available, it is used to speed up package installation. This optimization is optional and gracefully falls back to `conda` if `mamba` fails to install.
- **SpaCy Model:** The SpaCy `en_core_web_sm` model is downloaded to ensure compatibility with the installed version of SpaCy.
- **NeuralCoref:** This package is installed from `conda-forge` to support coreference resolution in NLP tasks.

### Savio-Specific Modules
The script loads the following modules:
- **Anaconda3:** Provides the Conda environment management system.
- **Python:** Ensures compatibility with the system Python installation and resolves module path issues.

### Testing
The script includes a testing phase where a Python test script is executed to verify the installation and functionality of Riveter NLP.

## Implementation Notes

1. **Logging:**
   - All outputs are logged to `install_riveter.log` for troubleshooting and verification.

2. **Repository Cloning:**
   - The Riveter NLP repository is cloned from GitHub if it is not already present in the working directory.

3. **Error Handling:**
   - Each step in the script is validated. Failure at any step will terminate the script and log an error message.

4. **Environment Reusability:**
   - The script removes and recreates the environment to avoid conflicts with residual configurations.

## Instructions

1. **Run the Script**:
   ```bash
   bash install-riveter.sh
   ```

2. **Verify Installation**:
   - Check the `install_riveter.log` file for successful installation logs.
   - Ensure the test script passes without errors.

3. **Common Issues**:
   - **Module Not Found:** Ensure the `Anaconda3` and `Python` modules are available on Savio.
   - **Package Conflicts:** Use the `mamba` installer to resolve dependency issues quickly.

For further assistance, refer to the [Berkeley Research Computing documentation](https://research-it.berkeley.edu/).

