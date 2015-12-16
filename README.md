# Fikri

<img src="https://dl.dropbox.com/s/dhw036evma45bb2/fikri.png" width="100" height="100" />


> Fikri is a TODO list manager.


## Installation

```bash
brew tap askn/fikri
brew install fikri
```

## Usage

Fikri has a very simple interface to manage your project.

### Add TODO list to your project.

Fikri creates a TODO file and manage your tasks, share with your code collaborators.

```
fikri init
```

will initialize a `.todos.yml` file into your project.

### Adding a task

To add a task, you need to pass `-a` parameter.

```
fikri -a "Buy some eggs."
```

### Toggling a task

You can switch a task to undone or done.

```
fikri -t 1
```

### Listin all tasks

To see the status of the tasks, use `-l` option.

```
fikri -l
```

## Roadmap

  - [ ] Add `TODO: .*` search feature in tasks.
  - [ ] Add GitHub issue sync feature.

## Contributing

1. Fork it ( https://github.com/askn/fikri/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [askn](https://github.com/askn) Aşkın Gedik - creator, maintainer
