# 🐜 anster

`anster` is a modular infrastructure as code template that glues Ansible and Terraform together to work seamlessly with each other.

[![Twitter](https://img.shields.io/static/v1?label=twitter&message=@JustinPerdok&style=flat-square&color=1D9BF0)](https://twitter.com/JustinPerdok)
![Terraform Version](https://img.shields.io/static/v1?label=Terraform&message=>=1.7.4&style=flat-square&color=5F43E9)
![Ansible Version](https://img.shields.io/static/v1?label=Ansible&message=>=2.11.5&style=flat-square&color=FF5850)
[![Github Actions](https://img.shields.io/github/workflow/status/justin-p/anster/CI?label=Github%20Actions&logo=github&style=flat-square)](https://github.com/justin-p/anster/actions)
[![Github License](https://img.shields.io/github/license/justin-p/anster?style=flat-square)](https://github.com/justin-p/anster/blob/main/LICENSE)

## Introduction

`anster` is a infrastructure as code template that combines Ansible and Terraform. [Ansible variables](#setting-up-the-host_list) are used to create a `terraform.tfvars` file. Ansible then calls Terraform to create the infrastructure using a map with optional variables. The output given by Terraform is then parsed by Ansible to [dynamically build it's inventory](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/add_host_module.html) and used to configure the created infrastructure.

`anster` can be used in a couple of ways:
- You quickly need a VM 'in the cloud' with some barebones config.
- You want to test/build a Ansible playbook/role against a server hosted by a cloud infrastructure provider.
- You want to build a project that can consistently spin up and configure the same specific set of infrastructure whenever you need it with a single command.

For more information, please refer to the wiki page [here](https://github.com/justin-p/anster/wiki).

## License

`anster` is licensed under a [GNU General Public v3 License](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Authors

Justin Perdok ([@justin-p](https://github.com/justin-p/)), Orange Cyberdefense

## Contributing

Feel free to open issues, contribute and submit your Pull Requests. You can also ping me on Twitter ([@JustinPerdok](https://twitter.com/JustinPerdok)).
