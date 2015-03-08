# A bash prompt framework

This is a simple infrastructure to customize your bash prompt, it comes with
some predefined prompts that you can use or customize at your wish.

## Testing the framework

To test the framework without installing go inside the repo directory and do:

    source prompter.bash
    prompter_select

This way the changes made to your prompt and your environment will only live in the current terminal.

## Install

There is not real installation requirements, just clone the repo in your home
folder (or make a link to it) and add this line to your bashrc:

    source ~/prompter/prompter.bash

## Usage

Select your prompt using the *prompter_select* command.

Or create your own just by adding a new file in prompter/prompts
