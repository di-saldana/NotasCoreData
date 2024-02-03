//
//  LibretaViewController.swift
//  NotasCoreData
//
//  Created by Dianelys Saldaña on 2/3/24.
//

import UIKit

class LibretaViewController: UIViewController {
    
    let miGestorPicker = GestorPicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func nuevaLibreta1() {
        let alert = UIAlertController(title: "Nueva libreta",
                                      message: "Escribe el nombre para la nueva libreta",
                                      preferredStyle: .alert)
        let crear = UIAlertAction(title: "Crear", style: .default) {
            action in
            let nombre = alert.textFields![0].text!
            //AQUI FALTA GUARDAR LA LIBRETA CON CORE DATA
            
            guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let miContexto = miDelegate.persistentContainer.viewContext
            
            let nuevaLibreta = Libreta(context: miContexto)
            nuevaLibreta.nombre = nombre
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel) {
            action in
        }
        alert.addAction(crear)
        alert.addAction(cancelar)
        alert.addTextField() { $0.placeholder = "Nombre"}
        self.present(alert, animated: true)
        
        performSegue(withIdentifier: "start", sender: nil)
    }
    
    func nuevaLibreta() {
        let alert = UIAlertController(title: "Nueva libreta",
                                      message: "Escribe el nombre para la nueva libreta",
                                      preferredStyle: .alert)
        let crear = UIAlertAction(title: "Crear", style: .default) { action in
            let nombre = alert.textFields![0].text!
            
            guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let miContexto = miDelegate.persistentContainer.viewContext
            
            let nuevaLibreta = Libreta(context: miContexto)
            nuevaLibreta.nombre = nombre
            self.miGestorPicker.libretas.append(nuevaLibreta)
            
            do {
                try miContexto.save()
            } catch {
                print("Error al guardar la nueva libreta: \(error)")
            }
            
            alert.dismiss(animated: true) {
                self.performSegue(withIdentifier: "start", sender: nil)
            }
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel) { action in }
        alert.addAction(crear)
        alert.addAction(cancelar)
        alert.addTextField() { $0.placeholder = "Nombre" }
        
        self.present(alert, animated: true)
    }


    
    @IBAction func nuevaLibreta(_ sender: UIButton) {
        nuevaLibreta()
    }
    
}
