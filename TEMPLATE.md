# Terraform Repository Template

## CodeSpaces

Developers can interact with this respository using GitHub CodeSpaces.  The
CodeSpace image provides the following software.

- python:  3.11.4
- boto3:  1.26.160
- docker:  24.0.2
- gh:  2.31.0
- terraform:  1.5.2
- tflint:  0.47.0
- checkov:  2.3.309
- ssm-tools:  1.6.0
- tfswitch:  0.13.1308

## Structure

## Variables

### Repository level variables

|Name|Description|Example|
|---|---|---|
|ENVIRONMENTS|Array of environment names.  These should match the environments defined in GitHub Environments|["dev01","test01","test02","prod01"]|
|TF_VERSION|Version of terraform used for the deployment|1.5.2|

### Environment level secrets

|Name|Description|Example|
|---|---|---|
|IDENTITY_ROLE|The role to be assumed in the identity account|dfe-dev-github|

### Environment level variables

|Name|Description|Example|
|---|---|---|
|TF_DYNAMO_TABLE|Terraform dynamo table for this account/environment||
|TF_STATE_BUCKET|Terraform state bucket for this account/environment||
|CONFIG|A json object all variables required for the environment deployment ( See below )||

#### CONFIG object

Variables contained in the CONFIG object will be passed to the terraform execution
as a tfvars.json ( printf '${{ inputs.CONFIG }}' > ./variables/input.tfvars.json ).  
The following variables are mandatory

    {
      "deployment_role_arn": "<ARN of the deployment role>"         # Eg. dfe-dev-deployment
      "account": "<account short name>",                            # Eg. dev
      "account_full": "<full name for the account>",                # Eg. DFE devlopment account
      "costcentre": "<cost centre>",                                # Eg. 123
      "deployment_mode": "<manual|auto>",                           # Eg. auto
      "deployment_repo": "<repo url containing deployment code>",   # Eg. https://github.com/Allwyn-UK/dfe-tf-infra.git
      "email": "<support contact email address>",                   # Eg. plateng@allwyn.co.uk
      "environment": "<environment short name>",                    # Eg. test01
      "environment_full": "<environment full name>",                # Eg. test01 - integration test
      "owner": "<team name of assets owner>",                       # Eg. Platform Engineering
      "project": "<project short name>",                            # Eg. DFE
      "project_full": "<project full name>"                         # Eg. Digital Front End
    }

## CI/CD - GitHub Actions

### Push to branch

### PR to main

### Push to main

## Adhoc actions

### Plan

### Deploy

#### Checkov

## Pre-Commit Hooks

Use Pre-Commit - see pre-commit-config.yaml

    check for added large files..............................................Passed
    check for merge conflicts................................................Passed
    fix end of files.........................................................Passed
    trim trailing whitespace.................................................Passed
    check yaml...............................................................Passed
    check that executables have shebangs.................(no files to check)Skipped
    Terraform fmt........................................(no files to check)Skipped
    tflint...............................................(no files to check)Skipped
    Checkov..............................................(no files to check)Skipped

## Security

### Main branch

* Branch protection on main
* Require PR with approval before merging
* Require signed commits
* Require status checks to pass before merging.
* Require deployments to succeed before merging ?? Which envs ??
* Push to main generates a semantic tag
* Tag protection rules ( Eg v* ).

### Deployments

* Only allow deployments from protected branches ( Even for dev? )
* Only allow deployments from tags ( Eg. v* )
* Deployment protection rules for environments ( Only for prod and prelive? )

### CODEOWNERS

#### OIDC

IAM trust for dev and test locked down to repo??

    "StringLike": {
      "token.actions.githubusercontent.com:sub": "repo:potteringabout/terraform-devops:*"
    }

Trust for prod locked down to tags??

    "StringLike": {
      "token.actions.githubusercontent.com:sub": "repo:potteringabout/terraform-devops:environment:prod*:ref:refs/tags/v*:ref_type:tag"
    }

## Notes

### Finding the GitHub Repository ID

Can be found with script

    #!/bin/bash
    gh auth login
    OWNER='your github username or organization name'
    REPO_NAME='your repository name'
    echo $(gh api -H "Accept: application/vnd.github+json" repos/$OWNER/$REPO_NAME) | jq .id

### GitHub OIDC subject

The OIDC subject passed to AWS by default contains the repository name and the context.
That might be

    repo: xxxx
    environment: dev01 - the GitHub environment.

We can customise at the repository level or org level what we gets passed in the token.

To see what gets passed...

    curl -L \
      -X GET \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer <YOUR-TOKEN>"\
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/repos/<org>/<repo>/actions/oidc/customization/sub

We need to use curl ( or something similar ) to update the subject.

    curl -L \
      -X PUT \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer <YOUR-TOKEN>"\
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/repos/<org>/<repo>/actions/oidc/customization/sub \
      -d '{"use_default":false,"include_claim_keys":["repo","context", "repository_visibility", "ref", "ref_type" ]}'
