#!/bin/bash
cd docker.mldev.base.jpt.gpu && make _build && cd ..
cd docker.mldev.base.ssh.cpu && make _build && cd ..
cd docker.mldev.base.ssh.gpu && make _build && cd ..
cd docker.mldev.spch.jpt.gpu && make _build && cd ..
cd docker.mldev.spch.ssh.cpu && make _build && cd ..
cd docker.mldev.spch.ssh.gpu && make _build && cd ..
