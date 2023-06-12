use magnus::{define_class, define_module, Module, function, Error};

fn merge_class_list(classes: &str, modifier_separator: &str) -> Vec<String> {
  // TODO!
  classes.trim().split_whitespace().map(|original_class_name| { original_class_name.to_string() }).collect()
}

fn merge(classes: String) -> String {
  // TODO!
  merge_class_list(&classes, ":").join(" ")
}

#[magnus::init]
fn init() -> Result<(), Error> {
  let twm = define_module("TailwindMerge")?;
  let module = twm.define_module("RustMerger")?;
  module.define_method("merge", function!(merge, 1))?;

  let merger = twm.define_class("Merger", magnus::class::object())?;
  merger.prepend_module(module)?;

  Ok(())
}
