# Sales Pal

A field-sales app: browse customers and products, build an order, submit it,
and keep it locally as Pending when submission fails.

## Running it

Generated code is not committed, so a fresh clone will not compile until you
run the generator:

```sh
flutter pub get
dart run build_runner build   # routes, assets, DI container
flutter run
```

That produces `lib/gen/assets.gen.dart`, `lib/core/navigation/app_routes.g.dart`
and `lib/core/di/injection.config.dart`. The routes file is a `part`, so
without it `flutter analyze` and `flutter test` report errors rather than
failing at runtime. Re-run after adding an asset, changing a route, or adding
an `@injectable` annotation — `dart run build_runner watch` does it for you
while developing.

```sh
flutter analyze   # expect zero issues
flutter test      # 112 tests
```

## Demoing both submission outcomes

Submission fails when the device genuinely cannot reach the internet, so both
outcomes are real rather than staged. The pill in the top bar reports the
current state.

**Success** — with a connection: open a customer → **Create Order** → add
products → **View Cart** → **Review Order** → **Submit**. The order appears
under **Submitted** in the Orders Queue.

**Failure** — turn on airplane mode and **wait for the pill to read Offline**,
then submit. You get **Submission Failed** with two ways out:

- **Save as Pending** — keeps the order in the queue to send later.
- **Retry** — leave airplane mode, wait for **Online**, press it, and the same
  screen becomes **Order Submitted!**.

**Persistence** — after saving one as Pending, kill and relaunch the app. It is
still in the queue, and **Retry Now** there promotes it to Submitted.

> The reachability check is an HTTP round trip, so it lags the radio by a
> moment. Wait for the pill before submitting, or you will get the state the
> app last saw.

## Architecture

Feature-first, with each feature split into the three layers Flutter
recommends:

```
lib/
  core/         connectivity, database, DI, failures, formatting, routing
  design/       tokens (spacing, radius, colours, typography) + components
  features/<feature>/
    data/         dtos, mappers, datasources, repository implementations
    domain/       entities, repository interfaces
    presentation/ cubit, pages, widgets
```

Dependencies point inward. `domain` holds entities and `abstract interface
class` repositories and knows nothing else; `data` implements them; the UI
talks only to cubits. `dartz`'s `Either<Failure, T>` carries expected failures
as return values rather than exceptions.

**State** is Bloc/Cubit. Three cubits are app-scoped singletons provided above
the router — the cart, the submission in flight, and connectivity. The rest
are `@injectable` and resolved per route in `app_routes.dart`.

**DI** is `get_it`, with `injectable` generating the registrations from
annotations, so wiring sits next to each class rather than in a hand-written
container. `main()` awaits `configureDependencies()`,
which also awaits opening the database via an `@preResolve` module.
Constructors take their dependencies explicitly, so unit tests build cubits
and repositories directly with fakes and never touch `get_it`.

**Data sources.** Customers and products are JSON assets read behind a short
delay, so loading states are real. Orders live in sqflite over two tables
(`orders`, `order_lines`, lines cascading), seeded from `assets/data/orders.json`
on first run. Since sqflite has no query streams, `OrderRepository` exposes a
`changes` stream that the queue and a customer's history listen to.

## Decisions

**Bloc/Cubit with sealed states.** Every screen here is a state machine —
loading, loaded, failed, submitting — so each `build` is an exhaustive `switch`
over a sealed class. Adding a state breaks compilation everywhere it has to be
handled, which is what stops a case being quietly forgotten.

**sqflite with a hand-written DAO.** Two tables and a handful of queries, so
the mapping is short enough to read in one sitting and needs no second code
generator.

**A failed order is never auto-saved.** `submit` writes nothing on failure —
`saveAsPending` is what the button calls. The rep stays in control of what
lands in their queue, and the button means what it says. The cost is that an
order could be lost by walking away, so the failure screen is terminal: Save
as Pending and Retry are its only exits.

**References are minted before submission.** A failed order still has to be
listed and retried under a name the rep recognises, so the reference exists
before the attempt rather than coming back from the backend.

**Line items snapshot the product.** A line stores the name and price it was
placed at rather than pointing at a `Product`, so a submitted order keeps its
prices when the catalogue moves on.

**The cart is app-scoped, with two entry points.** **Create Order** on a
customer attaches them and lands on the products tab — an order starts where
things get added. Browsing products first is also allowed; **View Cart** then
asks who the order is for. While a customer is attached the products footer
reads *"Ordering for …"* with a **Cancel**, because otherwise the pairing is
invisible and the next product added quietly joins someone's order. Leaving
the tab with nothing added drops the customer; a cart with items survives.

**Failure runs on the real connection.** This one changed during the build, so
it is worth recording: submission failure was first driven by a debug toggle in
the top bar. It demoed more easily but exercised nothing, so the toggle became
a read-only indicator and the offline path now runs on the device's actual
connection.

## What is mocked

No request leaves the app. `OrderApiService` is the "backend": it waits, then
succeeds or throws `OfflineException` depending on connectivity. Customers and
products come from bundled JSON. The only real network traffic is the
reachability check.

## Known limitations

- **Outstanding balance is reference data.** It is read from
  `assets/data/customers.json` and displayed; nothing updates it. Submitting an
  order does not move it, because the app models orders rather than accounts,
  and the source is a read-only asset with no customers table behind it.
- **Money is `double`.** Correct at the precision displayed, but the wrong type
  for money in earnest.
- **`CustomerDetailsRoute` passes the customer through `extra`**, so that URL is
  not deep-link safe. Fixing it means id-based lookup through
  `CustomerRepository.getCustomer`, which already exists.
- Orders cannot be edited once submitted, and there is no auth or sync.

## Testing

```sh
flutter test
```

112 tests across 17 files: cubit tests over fake repositories, DAO and
repository tests against a real in-memory SQLite (`sqflite_common_ffi`), widget
tests for the submission screens, and routing tests that walk the whole flow —
customer to products to cart to review to submitted.

Two things to know before adding widget tests. `testWidgets` runs in a
fake-async zone while sqflite completes on a real isolate, so anything reading
the database must go through `test/support/pumping.dart` or `pumpAndSettle`
will hang. And `rootBundle` caches the `Future`, not the string, so
`test/support/dependencies.dart` clears it between tests — otherwise a later
test awaits one created in an earlier test's disposed zone and never resumes.
