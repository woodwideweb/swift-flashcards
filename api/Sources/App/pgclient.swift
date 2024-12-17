import FluentKit
import FluentPostgresDriver

public struct PgClient {
  public let db: SQLDatabase

  public init(
    config: PostgresKit.SQLPostgresConfiguration,
    logger: Logger? = nil,
    numberOfThreads: Int = 1
  ) {
    self.init(
      factory: DatabaseConfigurationFactory.postgres(configuration: config),
      logger: logger,
      numberOfThreads: numberOfThreads
    )
  }

  public init(
    factory: DatabaseConfigurationFactory,
    logger: Logger? = nil,
    numberOfThreads: Int = 1
  ) {
    let configuration = factory.make()
    let eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads).any()
    let threadPool = NIOThreadPool(numberOfThreads: numberOfThreads)
    let driver = configuration.makeDriver(for: Databases(threadPool: threadPool, on: eventLoop))
    let context = DatabaseContext(
      configuration: configuration,
      logger: logger ?? Logger(label: "DuetSQL.PgClient"),
      eventLoop: eventLoop
    )
    db = driver.makeDatabase(with: context) as! SQLDatabase
    _shutdownHelper = ShutdownHelper(driver)
  }

  public func execute(raw: SQLQueryString) async throws -> [SQLRow] {
    try await db.raw(raw).all()
  }

  private let _shutdownHelper: ShutdownHelper
}

extension PgClient {
  private final class ShutdownHelper: Sendable {
    let driver: any DatabaseDriver

    init(_ driver: any DatabaseDriver) {
      self.driver = driver
    }

    deinit {
      self.driver.shutdown()
    }
  }
}
