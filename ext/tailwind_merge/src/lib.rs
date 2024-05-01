extern crate core;

use magnus::{function, scan_args, Error, Ruby, Value};
use tailwind_fuse::{merge::*, *};

fn define_merge_options(args: &[Value]) -> Result<bool, magnus::Error> {
    let args = scan_args::scan_args::<(), (), (), (), _, ()>(args)?;

    let kwargs = scan_args::get_kwargs::<_, (String, String), (), ()>(
        args.keywords,
        &["prefix", "separator"],
        &[],
    )?;

    let (rb_prefix, rb_separator) = kwargs.required;

    let merge_options = MergeOptions {
        prefix: rb_prefix.leak(),
        separator: rb_separator.leak(),
    };

    set_merge_options(merge_options);

    Ok(true)
}

fn merge(str1: String, str2: String) -> String {
    tw_merge!(str1, str2)
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let module = ruby.define_module("TailwindMerge")?;
    module.define_module_function("merge", function!(merge, 2))?;
    module.define_module_function("define_merge_options", function!(define_merge_options, -1))?;
    Ok(())
}
