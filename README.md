# Bus Delay Analysis in Toronto

## Overview

This repository contains the analysis and accompanying paper for the **Bus Delay Analysis in Toronto**. The study investigates the factors influencing bus delays using Bayesian regression modeling and provides actionable insights to improve transit reliability.


## File Structure

The repo is structured as:

-   `data/00-simulated_data` contains the simulated data generated for testing and validation purposes.
-   `data/01-raw_data` contains the raw bus delay data as obtained from Open Data Toronto or other sources.
-   `data/02-analysis_data` contains the cleaned dataset (`bus_delay_clean_data_2023.csv`) prepared for the analysis.
-   `model` contains the fitted models, including the Bayesian regression model (`delay_model.rds`).
-   `other` contains additional resources such as analyzed files, visualizations, sketches, and details about LLM interactions used in the project.
-   `paper` contains the files used to generate the final paper, including:
    -   `paper.qmd`: The Quarto document for generating the paper.
    -   `references.bib`: The bibliography file with all references cited in the paper.
    -   `paper.pdf`: The rendered PDF version of the paper.
-   `scripts` contains R scripts used to process and analyze the data:
    -   `00-simulate_data.R`: Generates simulated datasets for testing the analysis pipeline.
    -   `01-test_simulated_data.R`: Runs unit tests on the simulated data.
    -   `02-download_data.R`: Downloads raw data from Open Data Toronto.
    -   `03-clean_data.R`: Cleans and preprocesses the raw data for analysis.
    -   `04-test_analysis_data.R`: Performs quality assurance tests on the cleaned dataset.
    -   `05-exploratory_data_analysis.R`: Creates visualizations and summary statistics for exploratory data analysis.
    -   `06-model_data.R`: Fits the Bayesian regression model and saves the results to the `model` directory.


## Statement on LLM usage

This project utilized ChatGPT-4o to assist with specific aspects of the analysis and documentation process. 
The LLM was used in the following ways:

- **Code Assistance**: Provided suggestions for writing and optimizing R scripts, including data cleaning, testing, and Bayesian modeling.
- **Documentation**: Assisted in drafting sections of the paper, such as the results, references, appendix, and in creating this README file.
- **Technical Explanations**: Supported the development of clear and concise explanations of the methodology, findings, and model diagnostics.
- **Quarto and LaTeX Integration**: Offered guidance on formatting equations, tables, and figures within the Quarto `.qmd` document.

The entrie chat history can be found inside `others/llms/usage.txt`.