#!/bin/bash

# Set up environment variables
VENV_DIR="riveter_env"
REPO_URL="https://github.com/maartensap/riveter-nlp.git"
REPO_DIR="riveter-nlp"
LOG_FILE="install_riveter.log"

# Redirect stdout and stderr to log file
exec > >(tee -a $LOG_FILE) 2>&1

echo "Starting installation process for Riveter..."
date

# Load necessary modules
module spider python | grep "python/" || echo "No Python modules available"
module load python/3.10.12-gcc-11.4.0 || echo "Using system Python instead"

# Check Python version
if ! command -v python3 &> /dev/null; then
    echo "Python3 is not available. Please install Python3."
    exit 1
fi

# Create and activate a virtual environment
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv $VENV_DIR
    echo "Virtual environment created at $VENV_DIR"
fi

source $VENV_DIR/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install essential dependencies
pip install pandas spacy tqdm seaborn spacy_experimental

# Download SpaCy models
python -m spacy download en_core_web_sm
python -m spacy download en_coreference_web_trf

# Clone Riveter repository
if [ ! -d "$REPO_DIR" ]; then
    git clone $REPO_URL
    echo "Cloned Riveter repository"
fi

cd $REPO_DIR

# Install Riveter package
pip install . || pip install --use-feature=2020-resolver .

# Verify Riveter installation
echo "Verifying Riveter installation..."
TEST_SCRIPT="../test_riveter.py"
cat <<EOF > $TEST_SCRIPT
import riveter
import spacy_experimental

# Basic test to ensure the module imports and functions
print("Riveter and spacy_experimental imported successfully!")

# Additional functionality test
nlp = spacy_experimental.load("en_core_web_sm")
print("Loaded SpaCy model: en_core_web_sm")

nlp_coref = spacy_experimental.load("en_coreference_web_trf")
print("Loaded coreference model: en_coreference_web_trf")

sample_text = "Elizabeth Bennet is speaking. She said hello."
result = riveter.analyze_texts([sample_text])
print(result)
EOF

if python $TEST_SCRIPT; then
    echo "Riveter installation and test successful!"
else
    echo "Riveter test failed. Check logs for details."
    exit 1
fi

echo "Installation process completed."
date
