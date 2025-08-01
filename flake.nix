{
  outputs = _: {
    templates = {
      rust-lib = {
        path = ./templates/rust-lib;
        description = "A Rust library template.";
      };
      rust-bin = {
        path = ./templates/rust-bin;
        description = "A Rust binary template.";
      };
      gleam = {
        path = ./templates/gleam;
        description = "a Gleam template.";
      };
      deno = {
        path = ./templates/deno;
        description = "a Deno template.";
      };
    };
  };
}
