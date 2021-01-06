#!/usr/bin/python2

from entrypoint_helpers import env, gen_cfg

ZK_HOME = env["ZK_HOME"]

gen_cfg("zoo.cfg.j2", "{}/conf/zoo.cfg".format(ZK_HOME))

if "ZK_NODE_ID" in env:
    gen_cfg("myid.j2", "/var/lib/zookeeper/myid")