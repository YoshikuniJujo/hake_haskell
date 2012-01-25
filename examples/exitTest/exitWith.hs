import System.Exit
import System.Environment

main = getArgs >>= exitWith . ExitFailure . read . head
