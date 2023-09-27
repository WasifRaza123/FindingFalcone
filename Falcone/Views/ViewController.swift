//
//  ViewController.swift
//  Falcone
//
//  Created by Mohd Wasif Raza on 19/09/23.
//

import UIKit



class ViewController: UIViewController {
    let dispatchGroup = DispatchGroup()
    
    lazy var planetNames  = [String]()
    var planetDetails = [String: Int]()
    
    lazy var vehicleNames = [String]()
    var vehicleDetails = [String: [Int]]()
    
    let stackView = UIStackView()
    let vehicleStackView = UIStackView()
    
    var destinationAButton: UIButton!
    var destinationBButton: UIButton!
    var destinationCButton: UIButton!
    var destinationDButton: UIButton!
    
    var vehicleAButton: UIButton!
    var vehicleBButton: UIButton!
    var vehicleCButton: UIButton!
    var vehicleDButton: UIButton!
    
    var selectedPlanetButton: UIButton?
    var selectedVehicleButton: UIButton?
    
    var planetPickerView: UIPickerView!
    var vehiclePickerView: UIPickerView!
    
    var responsePlanetNames = [String]()
    var responseVehicleNames = [String]()
    
    var resultButton: UIButton!
    var resetButton: UIButton!
    
    private var planetViewModel: PlanetViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        callToViewModelForUIUpdate()
        createResultButton()
        createResetButton()
    }
    
    func callToViewModelForUIUpdate() {
        self.planetViewModel = PlanetViewModel()
        dispatchGroup.enter()
        self.planetViewModel.bindPlanetViewModelToController = {
            for item in self.planetViewModel.planetData {
                self.planetNames.append(item.name)
                self.planetDetails[item.name] = item.distance
            }
            DispatchQueue.main.async {
                self.setUpPlanets()
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        self.planetViewModel.bindVehicleViewModelToController = {
            for item in self.planetViewModel.vehiclesData {
                self.vehicleDetails[item.name] = [item.max_distance, item.total_no]
            }
            DispatchQueue.main.async {
                self.setUpVehicles()
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.applyConstraints()
        }
    }
    
    func setUpPlanets() {
        destinationAButton = createPlanetButton()
        destinationBButton = createPlanetButton()
        destinationCButton = createPlanetButton()
        destinationDButton = createPlanetButton()
        
        stackView.addArrangedSubview(destinationAButton)
        stackView.addArrangedSubview(destinationBButton)
        stackView.addArrangedSubview(destinationCButton)
        stackView.addArrangedSubview(destinationDButton)
        
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        
        planetPickerView = UIPickerView()
        planetPickerView.delegate = self
        planetPickerView.dataSource = self
    }
    
    func setUpVehicles() {
        vehicleAButton = createVehicleButton()
        vehicleBButton = createVehicleButton()
        vehicleCButton = createVehicleButton()
        vehicleDButton = createVehicleButton()
        
        vehicleStackView.addArrangedSubview(vehicleAButton)
        vehicleStackView.addArrangedSubview(vehicleBButton)
        vehicleStackView.addArrangedSubview(vehicleCButton)
        vehicleStackView.addArrangedSubview(vehicleDButton)
        
        vehicleStackView.axis = .vertical
        vehicleStackView.spacing = 20
        view.addSubview(vehicleStackView)
        
        vehiclePickerView = UIPickerView()
        vehiclePickerView.delegate = self
        vehiclePickerView.delegate = self
    }
    
    func createResultButton(){
        resultButton = UIButton()
        resultButton.setTitleColor(.black, for: .normal)
        resultButton.setTitle("show result", for: .normal)
        resultButton.layer.borderWidth = 1.0
        resultButton.layer.borderColor = UIColor.black.cgColor
        resultButton.addTarget(self, action: #selector(resultButtonClicked), for: .touchUpInside)
        view.addSubview(resultButton)
    }
    
    func createResetButton(){
        resetButton = UIButton()
        resetButton.setTitle("RESET", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.layer.borderWidth = 1.0
        resetButton.layer.borderColor = UIColor.black.cgColor
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
        view.addSubview(resetButton)
    }
    
    @objc func resetButtonClicked() {
        destinationAButton.isEnabled = true
        destinationBButton.isEnabled = true
        destinationCButton.isEnabled = true
        destinationDButton.isEnabled = true
        
        destinationAButton.backgroundColor = .white
        destinationBButton.backgroundColor = .white
        destinationCButton.backgroundColor = .white
        destinationDButton.backgroundColor = .white
        
        vehicleAButton.isEnabled = true
        vehicleBButton.isEnabled = true
        vehicleCButton.isEnabled = true
        vehicleDButton.isEnabled = true
        
        vehicleAButton.backgroundColor = .white
        vehicleBButton.backgroundColor = .white
        vehicleCButton.backgroundColor = .white
        vehicleDButton.backgroundColor = .white
        
        destinationAButton.setTitle("select planet", for: .normal)
        destinationBButton.setTitle("select planet", for: .normal)
        destinationCButton.setTitle("select planet", for: .normal)
        destinationDButton.setTitle("select planet", for: .normal)
        
        vehicleAButton.setTitle("select vehicle", for: .normal)
        vehicleBButton.setTitle("select vehicle", for: .normal)
        vehicleCButton.setTitle("select vehicle", for: .normal)
        vehicleDButton.setTitle("select vehicle", for: .normal)
        
        planetNames = []
        planetDetails = [:]
        vehicleDetails = [:]
        vehicleNames = []
        responsePlanetNames = []
        responseVehicleNames = []
        
        for item in self.planetViewModel.planetData {
            self.planetNames.append(item.name)
            self.planetDetails[item.name] = item.distance
        }
        
        for item in self.planetViewModel.vehiclesData {
            self.vehicleDetails[item.name] = [item.max_distance, item.total_no]
        }
        
    }
    
    @objc func resultButtonClicked(){
        self.planetViewModel.fetchFinalResult(token: self.planetViewModel.token, planetNames: responsePlanetNames, vehicleNames: responseVehicleNames)
    }
    
    func createPlanetButton() -> UIButton {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
        button.setTitle("select planet", for: .normal)
        return button
    }
    
    func createVehicleButton() -> UIButton {
        let button = UIButton()
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(showVehiclePickerView), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("select vehicle", for: .normal)
        return button
    }
    
    @objc func showPickerView(sender: UIButton) {
        selectedPlanetButton = sender
        planetPickerView.reloadAllComponents()
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(planetPickerView)
        
        let selectAction = UIAlertAction(title: "Select", style: .cancel) { _ in
            let selectedRow = self.planetPickerView.selectedRow(inComponent: 0)
            let planetName = self.planetNames[selectedRow]
            self.selectedPlanetButton?.setTitle(planetName, for: .normal)
            self.planetNames.removeAll(where: { $0 == self.planetNames[selectedRow] })
            self.selectedPlanetButton?.isEnabled = false
            self.selectedPlanetButton?.backgroundColor = .gray
            self.responsePlanetNames.append(planetName)
        }
        
        alertController.addAction(selectAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func showVehiclePickerView(sender: UIButton) {
        selectedVehicleButton = sender
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(vehiclePickerView)
        
        let selectedRow = self.vehiclePickerView.selectedRow(inComponent: 0)
        
        guard let destALabel = destinationAButton.titleLabel?.text else {return}
        guard let destBLabel = destinationBButton.titleLabel?.text else {return}
        guard let destCLabel = destinationCButton.titleLabel?.text else {return}
        guard let destDLabel = destinationDButton.titleLabel?.text else {return}
        
        
        self.vehicleNames = []
        
        switch sender {
        case vehicleAButton:
            for item in self.vehicleDetails {
                if item.value[1] > 0 && item.value[0] >= self.planetDetails[destALabel] ?? 999 {
                    self.vehicleNames.append(item.key)
                }
                
            }
        case vehicleBButton:
            for item in self.vehicleDetails {
                if item.value[1] > 0 && item.value[0] >= self.planetDetails[destBLabel] ?? 999 {
                    self.vehicleNames.append(item.key)
                }
            }
        case vehicleCButton:
            for item in self.vehicleDetails {
                if item.value[1] > 0 && item.value[0] >= self.planetDetails[destCLabel] ?? 999 {
                    self.vehicleNames.append(item.key)
                }
            }
        case vehicleDButton:
            for item in self.vehicleDetails {
                if item.value[1] > 0 && item.value[0] >= self.planetDetails[destDLabel] ?? 999 {
                    self.vehicleNames.append(item.key)
                }
            }
        default:
            print("Sdf")
        }
        
        let selectAction = UIAlertAction(title: "Select", style: .cancel) { _ in
            let selectedRow = self.vehiclePickerView.selectedRow(inComponent: 0)
            let vehicleName = self.vehicleNames[selectedRow]
            self.selectedVehicleButton?.setTitle(vehicleName, for: .normal)
            if var value = self.vehicleDetails[self.vehicleNames[selectedRow]] {
                value[1] = value[1] - 1
                self.vehicleDetails[self.vehicleNames[selectedRow]] = value
            }
            self.selectedVehicleButton?.isEnabled = false
            self.selectedVehicleButton?.backgroundColor = .gray
            self.responseVehicleNames.append(vehicleName)
        }
        
        alertController.addAction(selectAction)
        
        present(alertController, animated: true, completion: nil)
        vehiclePickerView.reloadAllComponents()
    }
    
    
    func applyConstraints() {
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        resultButton.translatesAutoresizingMaskIntoConstraints = false
        vehicleStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vehicleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            vehicleStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resultButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: resultButton.topAnchor, constant: -50),
        ])
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == planetPickerView {
                return planetNames.count
            }
            return vehicleNames.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == planetPickerView {
                return planetNames[row]
            }
            guard let nov = self.vehicleDetails[self.vehicleNames[row]]?[1] else { return nil}
            
            return "\(vehicleNames[row]) \((String(describing: nov)))"
            
        }
}
