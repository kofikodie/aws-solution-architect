# Terraform Project for SAA Certification

This project contains Terraform code for the SAA certification. It is designed to provision and manage infrastructure resources on AWS.

## Getting Started

To get started with this project, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/saa-c03.git
    ```

2. Switch to the desired branch for the specific service you want to work on:

    ```bash
    git checkout <branch-name>
    ```

3. Install Terraform:

    Follow the official [Terraform installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install Terraform on your machine.

4. Configure AWS credentials:

    Make sure you have valid AWS credentials configured on your machine. You can set them up using the AWS CLI or by exporting environment variables.

5. Initialize Terraform:

    ```bash
    terraform init
    ```

6. Deploy the infrastructure:

    ```bash
    terraform apply
    ```

    This will provision the necessary resources on AWS based on the Terraform code.

## Branches

This project is divided into branches, with each branch representing a specific service. You can switch to the desired branch to work on that particular service.

- `main`: Main branch containing the common infrastructure code.
- `service1`: Branch for Service 1.
- `service2`: Branch for Service 2.
- ...

Feel free to explore the different branches and contribute to the project.

## License

This project is licensed under the [MIT License](LICENSE).
