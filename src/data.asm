;;----------------------------------------------------------------------------------------------------------------------
;; Editor data
;;----------------------------------------------------------------------------------------------------------------------


SECTION STACK
org $bf00

        defs    256

SECTION PAGE_0
PUBLIC _testFile

_testFile:       binary "test.txt"
                defb    $1a
