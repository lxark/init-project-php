Init-project php just host useful files to initialize a project

Install makefile
-----------------

To install the makefile, just copy the files in the folder *"hooks"*.
You can also install them via scripts in your *composer.json*:

```
    "require-dev": {
        "lxark/init-project-php": "dev-master"
    },
    "scripts": {
        "post-install-cmd": [
            "cp vendor/lxark/init-project-php/makefile ."
        ],
        "post-install-cmd": [
            "cp vendor/lxark/init-project-php/makefile ."
        ]
    },
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/lxark/init-project-php.git"
        }
    ],
	"config": {
		"bin-dir": "bin"
	},
```

The bin dir is needed for the makefile.
I don't think Composer events are needed to install it automatically.