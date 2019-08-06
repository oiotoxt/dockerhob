#!/bin/bash
cd docker.mldev.base.jpt.gpu && make _push && cd ..
cd docker.mldev.base.ssh.cpu && make _push && cd ..
cd docker.mldev.base.ssh.gpu && make _push && cd ..
cd docker.mldev.spch.jpt.gpu && make _push && cd ..
cd docker.mldev.spch.ssh.cpu && make _push && cd ..
cd docker.mldev.spch.ssh.gpu && make _push && cd ..
