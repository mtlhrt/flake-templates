{
  outputs = _: {
    templates.nightly-rust = {
      path = ./templates/nightly-rust;
      description = "A nightly Rust template.";
    };
  };
}
