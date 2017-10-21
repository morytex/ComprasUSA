//
//  ProductRegisterViewController.swift
//  RafaelAlessandro
//
//  Created by Usuário Convidado on 21/10/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import CoreData

class ProductRegisterViewController: UIViewController {
    
    var product: Product!
    var smallImage: UIImage!
    var pickerView: UIPickerView!
    
    var stateDataSource: [State] = []
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var tfStateName: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swIsCreditCardPayment: UISwitch!
    @IBOutlet weak var btnAddUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tfName.placeholder = "Nome do produto"
        tfStateName.placeholder = "Estado da compra"
        tfValue.placeholder = "Valor (U$)"
        btnAddUpdate.titleLabel?.text = "CADASTRAR"
        
        if product != nil{
            btnAddUpdate.titleLabel?.text = "ATUALIZAR"

            tfName.text = product.name
            //            if let states = produto.states {
            //                tfEstadoProduto.text = states.map({($0 as! State).nome!})
            //            } else {
            //                print("o estado está vazio")
            //            }
            
            // tfValor.text = String( produto.valor )
            // swCartao.setOn(produto.cartao, animated: false)
            // btCadastrar.setTitle("Atualizar", for: .normal)
            if let picture = product.picture as? UIImage {
                ivPicture.image = picture
            }
        }
        
        loadState()
        setupPickerView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductRegisterViewController.handleTap))
        ivPicture.addGestureRecognizer(tapGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadState() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            stateDataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }

    // State picker
    func setupPickerView() {
        pickerView = UIPickerView() //Instanciando o UIPickerView
        pickerView.backgroundColor = .white
        pickerView.delegate = self  //Definindo seu delegate
        pickerView.dataSource = self  //Definindo seu dataSource
        
        //Criando uma toobar que servirá de apoio ao pickerView. Através dela, o usuário poderá
        //confirmar sua seleção ou cancelar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        //O botão abaixo servirá para o usuário cancelar a escolha de gênero, chamando o método cancel
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //O botão done confirmará a escolha do usuário, chamando o método done.
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        //Aqui definimos que o pickerView será usado como entrada do extField
        tfStateName.inputView = pickerView
        
        //Definindo a toolbar como view de apoio do textField (view que fica acima do teclado)
        tfStateName.inputAccessoryView = toolbar
    }
    
    func cancel() {
        tfStateName.resignFirstResponder()
    }
    
    func done() {
        if stateDataSource.count > 0 {
            tfStateName.text = stateDataSource[pickerView.selectedRow(inComponent: 0)].name
        }
        
        cancel()
    }

    func handleTap() {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde você quer escolher o imagem?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        //Criando o objeto UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //Definimos seu sourceType através do parâmetro passado
        imagePicker.sourceType = sourceType
        
        //Definimos a MovieRegisterViewController como sendo a delegate do imagePicker
        imagePicker.delegate = self
        
        //Apresentamos a imagePicker ao usuário
        present(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func addUpdateProduct(_ sender: UIButton) {
        if product == nil { product = Product(context: context) }
        
        product.name = tfName.text
        if smallImage != nil {
            product.picture = smallImage
        }
        product.state = nil
        product.value = Double( tfValue.text! )!
        product.isCreditCardPayment = swIsCreditCardPayment.isOn
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// Picture picker

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //O método abaixo nos trará a imagem selecionada pelo usuário em seu tamanho original
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        //Iremos usar o código abaixo para criar uma versão reduzida da imagem escolhida pelo usuário
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        //Atribuímos a versão reduzida da imagem à variável smallImage
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivPicture.image = smallImage //Atribuindo a imagem à ivPoster
        
        //Aqui efetuamos o dismiss na UIImagePickerController, para retornar à tela anterior
        dismiss(animated: true, completion: nil)
    }
}

// State picker

extension ProductRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return stateDataSource[row].name
    }
}

extension ProductRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    //Usaremos apenas 1 coluna (component) em nosso pickerView
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateDataSource.count //O total de linhas será o total de itens em nosso dataSource
    }
}
