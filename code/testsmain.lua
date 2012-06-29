
pcall(require, "luacov")    --measure code coverage, if luacov is present
require "lunatest"

lunatest.suite("tests.com.jessewarden.statemachine.StateMachineSuite")

print("--------------------------------")
print("-- Running StateMachine Tests --")
lunatest.run()