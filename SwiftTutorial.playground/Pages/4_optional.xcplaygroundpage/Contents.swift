/*:
 [Previous](@previous)

 ## Optional

 Swiftでは通常、変数に対してnilを代入することができません。
 それに対してnilを代入できるOptionalという型が用意されています。
 例えば、nilを代入できるInt型として`Int?`型があります。(正確にはOptionalにラップされているInt型`Optional<Int>`)

 > Try1: `number1` に `nil` を代入するように書き換えて、エラーになることを確認しましょう

 */
var number1: Int = 1
number1 = 100
// number1 = nil => nil cannot be assigned to type 'Int'

var number2: Int? = nil
number2 = 200
number2 = nil // => nil

/*:
 ### Optional Binding

 Optional型の変数はそのままで扱うことができず、非Optionalな値を取り出す必要があります。
 Optional Binding構文は、Optional型の変数が値を持っているかどうかを調べ、値が存在した場合はその値を変数として利用できます。

 */

func isOdd(_ value: Int) -> Bool {
    value / 2 != 0
}
let optionalNumber: Int? = 10
// isOdd(optionalNumber) // => Value of optional type 'Int?' must be unwrapped to a value type of 'Int'

if let optionalNumber {
    print(isOdd(optionalNumber) ? "odd" : "even")
} else {
    print("number is nil")
}

/*:
 guardを使って早期returnをする構文もあります。
*/

func isEven(_ value: Int?) -> Bool? {
    guard let value = value else {
        return nil
    }
    return value / 2 == 0
}

/*:
 ### Nil-Coalescing Operator
 Swiftには `??` というオペレータがあります。これは Nil-Coalescing Operator と呼ばれ、「Optionalな変数が値を持たなかった場合、デフォルトの値を使う」といった挙動を実現できます。
 */
let fullName = "Aoi Okawa"
let nickname: String? = "aoi"

// `nickname` が値を持っていたらそれを使い、なかったら `fullName` を使う。
let message3 = "Hi, \(nickname ?? fullName)!"

/*:
 ### Optional Chaining

 Optionalな値を便利に扱う構文として?.があり、Optional Chainingと呼ばれています。たとえばOptional型の変数xに対してx?.foo()という式を書いた場合、以下のように評価されます：

 - xがnilならfoo()の部分は無視され、x?.foo()はnilに評価されます。
 - xがnilでないならx?.foo()はx.foo()を呼び出し、その結果が式の値になります。
 
 なおx?.foo()という式全体に付く型はOptional型になります。Optional Chainingを使うといちいちnilかどうかでifを書かなくて済むようになったり、すぐ下で説明する!の利用箇所を減らせたりします。

 */
var optionalCharacters: [String]? = ["a", "b", "c"]

// 配列の先頭の値を大文字にする
// nilになる可能性があるので、必ずOptional型になる
let uppercased: String? = optionalCharacters?.first?.uppercased()

print(uppercased ?? "characters is nil")


/*:

### Implicity Unwrapped Optional

 `nil`でないことは分かっている一方で型レベルでOptionalをどうしても外せない場合、implicitly unwrapped optional (IUO)が使えます。
 IUOを使う場合、`?`ではなく`!`を型につけます。IUOはほぼOptional型と同じで、更に値のアンラップが自動的に行われます。アンラップしようとしたものの`nil`が入っていた場合、エラーになります。

*/

var iuoNumber: Int! = nil
// print(iuoNumber * 2) => Fatal error
iuoNumber = 100
print(iuoNumber * 2) // => 200

//: [Next](@next)
