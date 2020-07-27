// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum App {
    /// Henri Potier
    internal static let name = L10n.tr("Localizable", "app.name")
  }

  internal enum Basket {
    /// Your basket is currently empty!
    internal static let hasNotElements = L10n.tr("Localizable", "basket.hasNotElements")
    /// %.2f€
    internal static func sumAfterOffer(_ p1: Float) -> String {
      return L10n.tr("Localizable", "basket.sumAfterOffer", p1)
    }
    /// %.2f€
    internal static func sumBeforeOffer(_ p1: Float) -> String {
      return L10n.tr("Localizable", "basket.sumBeforeOffer", p1)
    }
    internal enum Cell {
      /// Quantity: %d
      internal static func quantity(_ p1: Int) -> String {
        return L10n.tr("Localizable", "basket.cell.quantity", p1)
      }
    }
  }

  internal enum BookStore {
    /// No books are currently on sale. :(
    internal static let hasNotElements = L10n.tr("Localizable", "bookStore.hasNotElements")
  }

  internal enum Button {
    /// Add to basket
    internal static let addToBasket = L10n.tr("Localizable", "button.addToBasket")
  }

  internal enum SelectedBook {
    /// %.2f€
    internal static func price(_ p1: Float) -> String {
      return L10n.tr("Localizable", "selectedBook.price", p1)
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
