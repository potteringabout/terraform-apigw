#!/usr/bin/env python3

import os
import re

sem_types = {"major":0, "minor":1, "micro":2 }
sem_update_type = "micro" # micro, minor or major
prefix = "v"
list_tags = "git tag -l"
semver_regex = "^" + prefix + "(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$"
semver_patern = re.compile(semver_regex)

def semantic_version(version):
  sv = semver_patern.match(version)
  if sv:
    return [sv.group(1), sv.group(2), sv.group(3)]

def run(command):
  stream = os.popen(command)
  output = stream.read().splitlines()
  return output

def get_tags():
  gh_tags = run(list_tags)
  tags = []
  for tag in gh_tags:
    semantic = semantic_version(tag)
    if semantic:
      tags.append(semantic)
  print(f"Semantic tags found {tags}")
  return tags

def latest_tag_by_type(sem_tags, major=None, minor=None):
  versions = []

  for tag in sem_tags:
    if major is None:
      versions.append(int(tag[sem_types["major"]]))
    if minor is None:
      if major == int(tag[sem_types["major"]]):
        versions.append(int(tag[sem_types["minor"]]))
    else:
      if major == int(tag[sem_types["major"]]) and minor == int(tag[sem_types["minor"]]):
        versions.append(int(tag[sem_types["micro"]]))

  return max(versions)

def next_tag(sem_tags, sem_type):
  major, minor, micro = 1, 0, 0

  if len(sem_tags) == 0:
    return f"{prefix}{major}.{minor}.{micro}"

  if sem_type == "major":
    major = latest_tag_by_type(sem_tags=sem_tags) + 1
  elif sem_type == "minor":
    major = latest_tag_by_type(sem_tags=sem_tags)
    minor = latest_tag_by_type(sem_tags=sem_tags, major=major) + 1
  elif sem_type == "micro":
    major = latest_tag_by_type(sem_tags=sem_tags)
    minor = latest_tag_by_type(sem_tags=sem_tags, major=major)
    micro = latest_tag_by_type(sem_tags=sem_tags, major=major, minor=minor) + 1
  return f"{prefix}{major}.{minor}.{micro}"


actor = os.environ['GITHUB_ACTOR']
message = os.environ['INPUT_MESSAGE']

stdout = run(f"git config --global --add safe.directory /github/workspace")
print(stdout)
stdout = run(f"git config user.name {actor}")
print(stdout)
stdout = run(f"git config user.email \"{actor}@users.noreply.github.com\"")
print(stdout)

tag = next_tag(sem_tags=get_tags(), sem_type=sem_update_type)

stdout = run(f"git tag -a {tag} -m \"{message}\"")
print(stdout)
stdout = run(f"git push origin {tag}")
print(stdout)
