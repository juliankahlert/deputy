# Deputy
> Dependency-Utility

Deputy is a tool for managing build dependencies in highly mixed repositories and those with large Git submodules. It can pull various archives, check out Git dependencies, and verify if the container/VM you are building in contains the necessary tools.

Deputy also offers rudimentary build capabilities, although this is not its primary focus. Its unique behavior is that it pulls/checks all dependencies first before attempting to build.

Deputy supports `finalize` commands that run regardless of the success or failure of the pulls/checks and build processes at the very end. Deputy is designed to be run before more powerful build systems like `make` or `cmake` and is not intended to replace fully featured build systems.

## Usage

Run Deputy in the current working directory:
```sh
./deputy
```

Run Deputy in a different directory than the current working directory:
```sh
./deputy -C dir/with/the/.dep/yaml/file
```

### .dep.yaml

The `.dep.yaml` file for Deputy serves a similar purpose as the `Makefile` for `make`.

```yaml
---
repo:
  meta:
    name: Example 1
    descr: |-
      This is a test repository to serve as an example
      of `deputy`.
    tags:
    - example
    - meta
    - bin
    - git
    - zip
    - tgz

  finalize:
  - step: Chown directory
    descr: Change ownership of the directory to ensure user 1000 and group 1000 own it
    exec:
      cmd: chown
      args:
      - 1000:1000
      - -R
      - ./
  - step: List directory
    descr: Show directory contents to verify everything is okay
    exec:
      echo-always:
        stdout: true
      cmd: ls
      args:
      - -l
      - -a

  deps:
  - name: "gcc"
    descr: Check for binaries in the PATH
    type: bin
    uri: path://gcc
  - name: "some_file.txt"
    descr: Check for files relative to the .dep.yaml
    type: bin
    uri: file://some_file.txt
  - name: "os-release"
    descr: Check for files with an absolute path
    type: bin
    uri: file:///etc/os-release
  - name: "Git submodule"
    descr: Check/clone/checkout Git repositories
    type: git
    uri: https://github.com/octocat/Hello-World.git
    ref: commit://553c2077f0edc3d5dc5d17262f6aa498e69d6f8e
    dst: dir://hello
  - name: "submodule from remote zip"
    descr: Pull a zip archive and check integrity with various hash sums
    type: zip
    uri: https://github.com/octocat/Hello-World/archive/refs/heads/master.zip
    dst: dir://hello-master-from-zip
    ref: md5://4ca5a69183a1945509f86f8d72ceee8e
  - name: "submodule from remote tar.gz"
    descr: Supports tar.gz archives as well
    type: tgz
    uri: https://github.com/octocat/Hello-World/archive/refs/heads/master.tar.gz
    dst: dir://hello-master-from-tgz
    ref: sha256://ab7006ec9cea1c8cb012961328029a9d178e947ab6f997c6dbae12a9019407a4
    build:
    - step: List directory
      descr: Show directory contents to verify everything is okay
      exec:
        echo-always:
          stdout: true
        cmd: ls
        args:
        - -l
        - -a
  - name: "submodule from local tar.gz"
    descr: Local files can be used as archives
    type: tgz
    recurse: true
    uri: file://.deputy-cache/042d8425db625832a8414b727e9966d7.tar.gz
    dst: dir://hello-master-from-local-tgz
    ref: sha1://fd980d2c9b6ae007659f6067ddd5aca4d5e108dd
```

## Future Development

Plans include porting Deputy to `Rust` and providing a static binary for all major architectures to enhance its utility.

## License

MIT
