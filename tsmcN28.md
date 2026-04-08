





### layout virtuoso skill code


```lisp
procedure( Add_DMEXCLD_layers()
    let((cv targetShapes newFig)
        cv = geGetEditCellView()
        targetShapes = setof(s cv~>shapes 
            s~>layerName == "DMEXCL" && 
            s~>purpose == "dummy5" && 
            member(s~>objType '("rect" "polygon"))
        )
        foreach(s targetShapes
            foreach(sfx '("1" "2" "3" "4" "6" "7" "8" "9" "a" "b" "c" "d")
                newFig = dbCopyFig(s cv list(0:0 "R0" 1))
                newFig~>purpose = strcat("dummy" sfx)
            )
        )
        t
    )
)
```
