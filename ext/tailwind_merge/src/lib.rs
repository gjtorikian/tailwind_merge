extern crate core;

use magnus::{function, prelude::*, Error, Ruby};
use tailwind_fuse::tw_merge;

fn merge(str1: String, str2: String) -> String {
    tw_merge!(str1, str2)
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let module = ruby.define_module("TailwindMerge")?;
    module.define_module_function("merge", function!(merge, 2))?;
    Ok(())
}
