# Helper function to create mocked call_gh bindings
local_mocked_call_gh <- function(mock_fn, .env = rlang::caller_env()) {
  local_mocked_bindings(
    call_gh = mock_fn,
    .env = .env
  )
}
