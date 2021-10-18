//
//  ViewController.swift
//  markdown
//
//  Created by rehanchrl on 22/09/21.
//

import UIKit
import MarkdownKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var secondText: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        doParse()
    }

    func doParse() {
//        let markdownParser = MarkdownParser()
        let markdown = "Can be filled by [link](https://mekari.com) or like this https://mekari.com, with possibility to put font with **bold**, *italic*, <u>underline</u>, ~~strikethrough~~, or **_~~combine~~_** style.<br>Also description should be possible to do general mention like this @[all:All] @[online:Online] and personal mention like this @[userid_62_talenta.owner2.yopmail.com@pt-sso-ch-7bemvidmbpb.com:mekarian user]. To read more, [click **_here_**](https://example.com)"
        let htm = "<p>Hello world !!</p><p><br></p><ol><li>cuci tangan</li><li>pakai masker</li><li>---</li></ol><p><br></p><p>\t\t\tTab here</p><p><br></p><p><strong>Bold. <u>Underlined_Bold </u></strong></p>"
        
        let markdownParser = MarkdownParser(customElements: [MarkdownUnderline(), MarkdownNewLine()])
        
        
        let x = markdownParser.parse(markdown)
        var resultHtmlText = ""
        do {

            let r = NSRange(location: 0, length: x.length)
            let att = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]

            let d = try x.data(from: r, documentAttributes: att)

            if let h = String(data: d, encoding: .utf8) {
                resultHtmlText = h
            }
        }
        catch {
            print("utterly failed to convert to html!!! \n>\(x)<\n")
        }
        print(resultHtmlText)
        
        mainText.attributedText = htm.htmlToAttributedString
        secondText.attributedText = htm.htmlToAttributedStringTalenta
        
        webView.loadHTMLString("<!DOCTYPE html><html><body>\(htm)</body></html>", baseURL: nil)
    }

}

class MarkdownUnderline: MarkdownElement {
    static let regex = "(<(\\s)*u[^>]*>)(.*?)(<(\\s)*(\\/)(\\s)*u>)"
    
    var regex: String {
      return MarkdownUnderline.regex
    }
    
    func regularExpression() throws -> NSRegularExpression {
        return try NSRegularExpression(pattern: regex, options: [])
    }
    
    
    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        
        attributedString.deleteCharacters(in: match.range(at: 4))
        attributedString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], range: match.range(at: 3))
        attributedString.deleteCharacters(in: match.range(at: 1))
    }
}

class MarkdownNewLine: MarkdownElement {
    static let regex = "(<br(\\s)*/?>)"
    
    var regex: String {
        return MarkdownNewLine.regex
    }
    
    func regularExpression() throws -> NSRegularExpression {
        return try NSRegularExpression(pattern: regex, options: [])
    }
    
    func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
        attributedString.replaceCharacters(in: match.range(at: 1), with: NSAttributedString(string: "\n"))
    }
    
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
          return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
          return NSAttributedString()
        }
      }
      
    var htmlToAttributedStringTalenta: NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16,
                                           allowLossyConversion: false) else { return nil }
                do {
                    let html = try NSMutableAttributedString(
                        data: data,
                        options: [.documentType: NSAttributedString.DocumentType.html],
                        documentAttributes: nil)
                    return html
                } catch _ {
                    return nil
                }
      }
      var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
      }

}
