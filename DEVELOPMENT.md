# Development Setup

## Python

### Conda Setup
Conda is used as the main environment manager. The following step-by-step should be used on the local machine (if conda is not already installed).

#### Installation

1. Download the installer script from conda
	
		wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  
		
1. Run the installer script and accept the defaults parameters

		chmod u+x Miniconda3-latest-Linux-x86_64.sh  
		./Miniconda3-latest-Linux-x86_64.sh  
	
1. Configure the conda command to be available at all time. If you use any other shell (i.e. bash, zsh, fish, etc.), you will have to change `zsh` in the following commands. It is assumed that you installed miniconda in `~/miniconda3`.
		
		eval "$(~/miniconda3/bin/conda shell.bash hook)"  
		conda init zsh
		
#### Basic setup

At least two environments should be created. One for running jupyter and the others as your development environment.

* **Env `jupyter`**

	This environement will be used to run the juypter notebook command.
	
	1. Create environment
	
			conda create -n jupyter python=3
			conda activate jupyter
			
	2. Install the [nb_conda_kernels](https://github.com/Anaconda-Platform/nb_conda_kernels) extension

			conda install nb_conda_kernels
			
	2. Generate base config file

			jupyter notebook --generate-config  
			
		* Create a password protection for your notebooks (also avoids having to provide a token)

				jupyter notebook password
		
*  **Env `dev`**
	
	This environment can be named however you like. It will be the environment used to install all your project dependencies. You should create at least one per project.
	
	> **Every time you want to install something in your environment from the console, don't forget to activate the corresponding conda env!**
	
	1. Create environment
	
			conda create -n myfirstproject python=3.5
			conda activate myfirstproject
			
	2. Make its kernel available in notebooks

			pip install ipykernel
	

	Finally, you can launch the jupyter server using
			
			conda activate jupyter
			jupyter notebook 
			 
	After launching the jupyter server, it will be available from your local browser on `localhost:8888`. 
	
	This will provide you with access to the file system local to the jupyter server. Also, thanks to the ipykernel, you can change between all your conda environment __without ever having to restart__ the jupyter server.
	
### Version control of Notebooks

As notebooks are just plain text files, they can be version controlled easily.

> As a rule, only the cleaned notebooks should be committed

#### Usage

Usage is transparent for the user. Every time a commit is created, every `.ipynb` file will be filtered. This doesn't influence the file itself but only the commited file. Currently, the filter remove empty cell and cleanup the outputs.

If you want to commit a notebook **as is**, you can modify the notebook metadata to indicate your wish.

1. Edit the metadata using *Edit > Edit Notebook Metadata*
2. Add a new item in the metadata dictionary

		"git": {
			"clear_output": false,
		}
		
> **By default the notebook are cleaned**

#### Setup

A small [git filter](https://git-scm.com/docs/git-filter-branch) that will do the work for you and make sure you only commit clean notebooks can be used.

1. Install [jq](). Necessary library to be able to parse the json .ipynb files.
 			
		brew install jq
    
1. Create a [gitattribute](https://www.git-scm.com/docs/gitattributes) file with at least the following content

		*.ipynb filter=nbstrip_full

	
	This will run the `nbstrip_full` every time you call `diff` or when you commit `.ipynb` files
	
	
	##### Where to place the `attribute`file?
	
	
	###### Affect only _a single_ repository
	
	* When the command should be applied by everybody (and everybody is setup correctly), create a `.gitattributes` in your root project directory. This will make the `.gitattributes` trackable by git 
	* When you don't want to track the `.gitattributes` file you can instead create it as `.git/info/attributes`
		
	###### Affect _all_ repository
	
	1. Create a `.gitattributes.base` file in your home
	2. Run the command

			git config --global core.gitattributesfile ~/.gitattributes.base

1. Add the `nbstrip_full` filter to your [gitconfig](https://git-scm.com/docs/git-config#FILES) file 


		[filter "nbstrip_full"]
		    clean = "jq --indent 1 'if ((.metadata | has(\"git\") | not) or (.metadata.git | has(\"clear_output\") | not)) or .metadata.git.clear_output then \
		            (.cells[] | select(has(\"outputs\")) | .outputs) = [] \
		            | (.cells[] | select(has(\"execution_count\")) | .execution_count) = null \
		            | .cells[].metadata = {} \
		            | del(.cells[] | select(.source == [])) \
		            | .metadata = {\"language_info\": {\"name\": \"python\", \"pygments_lexer\": \"ipython3\"}} \
		            else . end'"
		    smudge = cat
		    required = true