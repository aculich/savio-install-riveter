# Installation Script for Riveter NLP on Savio

This document describes the steps and decisions made in creating the installation script for Riveter NLP as of December 2024. It also explains the configurations specific to the Berkeley Research Computing (BRC) Savio environment.

## Important Setup Instructions

Before running the installation script, ensure that your environment is configured to automatically load the Anaconda module upon login. This ensures that the `conda` command and related functionalities are available.

### Automating Anaconda Module Loading

1. **Update your Bash Configuration:** Add the following line to your `.bashrc` or `.bash_login` file:
   ```bash
   module load anaconda3
   ```
   - This line ensures that the required Anaconda module (`anaconda3/2024.02-1-11.4`) is loaded automatically upon login to Savio.

2. **Verify Configuration:** After updating your bash configuration, you can log out and log back in, then run:
   ```bash
   module list
   ```
   to confirm that `anaconda3` is loaded.

3. **Manual Activation:** If needed, manually load the module and activate the environment using the following commands:
   ```bash
   module load anaconda3
   conda activate riveter
   ```

## Key Configurations and Decisions

### Conda Environment Management

- **Environment Name:** The environment is named `riveter` for consistency and clarity.
- **Clean Install:** The script removes any existing environment with the name `riveter` before creating a new one. This ensures a clean slate for every installation.
- **Channel Configuration:** The `conda-forge` channel is added for accessing packages not available in the default channel.

### Python Version

The script uses Python version 3.6, which is explicitly pinned to ensure compatibility with the `neuralcoref` package. Error messages during the installation process indicated that `neuralcoref` requires Python versions `>=3.6,<3.7.0a0` or `>=3.7,<3.8.0a0`. To meet these requirements, Python 3.6 is selected. This version also aligns with other dependency requirements, ensuring stability.

### Savio-Specific Modules

- **Anaconda3 Module:**
  - The `module load anaconda3` command is essential to enable the use of Conda and activate the environment. The script uses the specific version `anaconda3/2024.02-1-11.4` to ensure compatibility with Python 3.6.
  - After loading this module, activate the environment using `conda activate riveter`.

### Dependency Installation

- **Pinned Dependencies:** The following packages are installed with specific versions for compatibility:
  - `spacy=2.3`: Compatible with `neuralcoref`.
  - `pandas`: For data manipulation.
  - `tqdm`: For progress bar utilities.
  - `seaborn`: For data visualization.
- **Mamba Utilization:** If `mamba` is available, it is used to speed up package installation. This optimization is optional and gracefully falls back to `conda` if `mamba` fails to install.
- **NeuralCoref:** Installed from `conda-forge` to support coreference resolution in NLP tasks.
- **SpaCy Model:** The SpaCy `en_core_web_sm` model is downloaded to ensure compatibility with SpaCy 2.3.

### Testing

The script includes a testing phase where a Python test script (`test_riveter.py`) is executed to verify the installation and functionality of Riveter NLP. The test uses the `neuralcoref` and SpaCy pipeline to process a sample text.

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

3. **Activating the Environment**: After loading the Anaconda module, activate the environment using:

   ```bash
   conda activate riveter
   ```

4. **Automating Module Loading**: Add the following line to your `.bashrc` or `.bash_login` file to automatically load the Anaconda module upon login:

   ```bash
   module load anaconda3
   ```

5. **Common Issues**:

   - **Module Not Found:** Ensure the `Anaconda3` module is available on Savio.
   - **Package Conflicts:** Use the `mamba` installer to resolve dependency issues quickly.

## References

- **Conda Documentation:** [https://docs.conda.io/](https://docs.conda.io/)
- **Conda-Forge Channel:** [https://conda-forge.org/](https://conda-forge.org/)
- **NeuralCoref GitHub Repository:** [https://github.com/huggingface/neuralcoref](https://github.com/huggingface/neuralcoref)
- **Savio Documentation:** [https://research-it.berkeley.edu/services/high-performance-computing](https://research-it.berkeley.edu/services/high-performance-computing)

For further assistance, refer to the [Berkeley Research Computing documentation](https://research-it.berkeley.edu/).

