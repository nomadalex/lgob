local es = expandStr
shell( es'$INSTD $DEST/$SHARED' )
shell( es'$INSTD $DEST/bin' )
shell( es'$INST codegen/src/*.lua $DEST/$SHARED' )
shell( es'$INST codegen/src/generator.lua $DEST/bin/lgob-generator' )
shell( es'$INST codegen/src/gir-parser.lua $DEST/bin/lgob-gir-parser' )
shell( es'$CHMOD $DEST/bin/lgob-generator' )
shell( es'$CHMOD $DEST/bin/lgob-gir-parser' )
shell( es'$CHMOD $DEST/$SHARED/generator.lua' )
