//
//  Nota+Custom.swift
//  NotasCoreData
//
//  Created by Dianelys Saldaña on 2/3/24.
//

import Foundation

extension Nota {
    //Devuelve una subcadena solo con la primera letra del texto
    @objc var inicial: String? {
        if let textoNoNil = self.contenido, !textoNoNil.isEmpty {
            return String(textoNoNil.first!)
        }
        else {
            return "Empty"
        }
    }
}
