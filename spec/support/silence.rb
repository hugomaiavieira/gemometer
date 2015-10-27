def silence
  # Store the original stderr and stdout in order to restore them later
  @original_stderr, @original_stdout = $stderr, $stdout

  # Redirect stderr and stdout
  $stderr = $stdout = StringIO.new

  yield

  # Back to normal
  $stderr, $stdout = @original_stderr, @original_stdout
  @original_stderr, @original_stdout = nil, nil
end