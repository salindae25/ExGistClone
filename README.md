# GistClone

## Introduction

This project is copied from [Elixir Mentor YouTube channel](https://www.youtube.com/@elixirmentor)
Gist Clone project. After watching the first 12 episodes and following along, 
I have incorporated additional functionality and views inspired by the UIs showcased in the initial episode.

## Run

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Features needed to be added

- [ ] pagination for the list views ( all gist, yours gist, saved )
- [ ] search gists
  - [ ] search based on name
  - [ ] search based on file prefix ex:- \*.heex
- [ ] broadcast when gist saved to sessions that accessing that gist.
- [ ] broadcast when commented on gist to sessions that accessing that gist.
- [ ] order comment based on added date.
- [ ] load comment based on "Load more" button ( pagination for comment)
