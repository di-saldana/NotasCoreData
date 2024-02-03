//
//  ViewController.swift
//  NotasCoreData
//
//  Created by Dianelys Saldaña on 2/1/24.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var libretaPicker: UIPickerView!
    
    let miGestorPicker = GestorPicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.libretaPicker.delegate = self.miGestorPicker
        self.libretaPicker.dataSource = self.miGestorPicker
        self.miGestorPicker.cargarLista()
        self.libretaPicker.reloadAllComponents()
    }

    @IBAction func create(_ sender: UIButton) {
        dateLabel.text = ""
        textView.text = ""
        messageLabel.text = ""
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let numLibreta = self.libretaPicker.selectedRow(inComponent: 0)
        let libretaSeleccionada = self.miGestorPicker.libretas[numLibreta]
        
        let nuevaNota = Nota(context: miContexto)
        nuevaNota.fecha = Date()
        nuevaNota.texto = textView.text
        
        nuevaNota.libreta = libretaSeleccionada
        
        do {
            try miContexto.save()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateLabel.text = dateFormatter.string(from: nuevaNota.fecha!)
            messageLabel.text = "Nota guardada correctamente"
        } catch {
            print("Error al guardar el contexto: \(error)")
            messageLabel.text = "Error al guardar la nota"
        }
    }
}
