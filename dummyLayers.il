procedure( Add_DMEXCLD_layers(@optional (maxDepth 1) (mode 1))
    let((topCv)
        topCv = geGetEditCellView()
        if( topCv then
            Add_DMEXCLD_recursive(topCv topCv list(0:0 "R0" 1.0) 0 maxDepth mode)
            t
        else
            nil
        )
    )
)

procedure( Add_DMEXCLD_recursive(cv topCv currentTransform currentDepth maxDepth mode)
    let((targetShapes newFig newTransform elemTrans instTrans mosaicBaseTrans)
        targetShapes = setof(s cv~>shapes 
            s~>layerName == "DMEXCL" && 
            s~>purpose == "dummy5" && 
            member(s~>objType '("rect" "polygon"))
        )
        foreach(s targetShapes
            foreach(sfx '("1" "2" "3" "4" "6" "7" "8" "9" "a" "b" "c" "d")
                newFig = dbCopyFig(s topCv currentTransform)
                if(newFig then
                    newFig~>purpose = strcat("dummy" sfx)
                )
            )
            if(mode >= 2 then
                newFig = dbCopyFig(s topCv currentTransform)
                if(newFig then
                    newFig~>layerName = "POBLK"
                    newFig~>purpose = "dummy"
                )
                newFig = dbCopyFig(s topCv currentTransform)
                if(newFig then
                    newFig~>layerName = "ODBLK"
                    newFig~>purpose = "dummy"
                )
            )
            if(mode >= 3 then
                foreach(sfx '("1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c")
                    newFig = dbCopyFig(s topCv currentTransform)
                    if(newFig then
                        newFig~>layerName = "DVIAEXCL"
                        newFig~>purpose = strcat("dummy" sfx)
                    )
                )
            )
            if(mode == 4 then
                foreach(sfx '("1" "2" "3" "4" "5" "6" "7" "8" "9")
                    newFig = dbCopyFig(s topCv currentTransform)
                    if(newFig then
                        newFig~>layerName = "MOMDMY"
                        newFig~>purpose = strcat("dummy" sfx)
                    )
                )
            )
        )
        if( currentDepth < maxDepth then
            foreach(inst cv~>instances
                if(inst~>master then
                    newTransform = dbConcatTransform(inst~>transform currentTransform)
                    Add_DMEXCLD_recursive(inst~>master topCv newTransform currentDepth+1 maxDepth mode)
                )
            )
            foreach(mosaic cv~>mosaics
                if(mosaic~>master then
                    mosaicBaseTrans = list(mosaic~>xy mosaic~>orient 1.0)
                    for(r 0 mosaic~>rows-1
                        for(c 0 mosaic~>columns-1
                            elemTrans = list( list(c * mosaic~>uX  r * mosaic~>uY) "R0" 1.0)
                            instTrans = dbConcatTransform(elemTrans mosaicBaseTrans)
                            newTransform = dbConcatTransform(instTrans currentTransform)
                            Add_DMEXCLD_recursive(mosaic~>master topCv newTransform currentDepth+1 maxDepth mode)
                        )
                    )
                )
            )
        )
    )
)
