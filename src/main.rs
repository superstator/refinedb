use rusqlite::Connection;
use barrel::backend::Sqlite as Sql;
use refinery::Error;


mod embedded {
    use refinery::embed_migrations;
    embed_migrations!("migrations");
}

#[cfg(feature = "enums")]
use embedded::migrations::EmbeddedMigration;

fn main() -> Result<(), Error> {
    let mut conn = Connection::open("test.db").unwrap();

    for migration in embedded::migrations::runner().run_iter(&mut conn) {
        #[cfg(feature = "enums")]
        match migration?.into() {
            EmbeddedMigration::Initial(_) => init_filesystem()?,
            EmbeddedMigration::AddCarsAndMotosTable(_) => migrate_v2()?,
            m => println!("migration: {:?}", m)
        }
    }

    Ok(())
}

fn init_filesystem() -> Result<(), Error> {
    // create fs junk
    println!("writing fs");
    Ok(())
}

fn migrate_v2() -> Result<(), Error> {
    // update fs junk folowing db changes
    println!("migrating fs");
    Ok(())
}