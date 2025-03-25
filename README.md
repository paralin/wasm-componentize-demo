# ComponentizeJS Example

This repo demonstrates how to use ComponentizeJS to create and use WebAssembly components from JavaScript.

This implementation is based on the [ComponentizeJS example](https://github.com/bytecodealliance/ComponentizeJS/blob/main/EXAMPLE.md).

## Setup

```bash
# Install dependencies
npm install

# Install jco globally
npm install -g @bytecodealliance/jco
```

## Building the Component

Run the build script:

```bash
./build.bash
```

This will:
1. Build the WebAssembly component from hello.js and hello.wit
2. Transpile the component with jco
3. Set up the hello directory with npm

## Running the Component in Node.js

After building, you can run the component with:

```bash
node -e "import('./hello/hello.component.js').then(m => console.log(m.hello('ComponentizeJS')))"
```

Expected output:
```
Hello ComponentizeJS
```

## Running the Component in Wasmtime (Optional)

To run the component in Wasmtime, you need to set up a Rust host.

1. Create a new Rust project:
```bash
mkdir -p host
cd host
cargo init
```

2. Update Cargo.toml with:
```toml
[dependencies]
wasmtime = "17.0.0"
wasmtime-wasi = "17.0.0"
wit-bindgen = { version = "0.20.0", default-features = false, features = ["wasmtime"] }
```

3. Create src/main.rs with:
```rust
wasmtime::component::bindgen!({world: "hello", path: "../hello.wit"});

fn main() -> wasmtime::Result<()> {
    let engine = wasmtime::Engine::default();
    let component = wasmtime::component::Component::from_file(
        &engine,
        "../hello.component.wasm",
    )?;

    let mut linker = wasmtime::component::Linker::new(&engine);
    let mut store = wasmtime::Store::new(&engine, ());

    let (hello, _) = Hello::instantiate(&mut store, &component, &linker)?;
    let result = hello.call_hello(&mut store, "ComponentizeJS")?;
    println!("> {}", result);

    Ok(())
}
```

4. Build and run:
```bash
cargo build --release
./target/release/host
```

Expected output:
```
> Hello ComponentizeJS
```
