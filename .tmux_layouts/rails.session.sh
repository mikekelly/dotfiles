session_root "$PWD"

if initialize_session "rails"; then
  new_window "vim"
    run_cmd "vim"

  new_window "log"
    run_cmd "powder applog"

  new_window "flex"
    run_cmd "bundle"

  select_window 0
fi

finalize_and_go_to_session
