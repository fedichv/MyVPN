import UIKit
import NetworkExtension

class ViewController: UIViewController {

    private let vpnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подключить VPN", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var isConnected = false
    private let vpnManager = NEVPNManager.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupVpnButton()
        loadVPNPreferences()
    }

    private func setupVpnButton() {
        view.addSubview(vpnButton)
        NSLayoutConstraint.activate([
            vpnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vpnButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vpnButton.widthAnchor.constraint(equalToConstant: 200),
            vpnButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        vpnButton.addTarget(self, action: #selector(vpnButtonTapped), for: .touchUpInside)
    }

    @objc private func vpnButtonTapped() {
        isConnected.toggle()
        updateButtonTitle()

        if isConnected {
            startVPN()
        } else {
            stopVPN()
        }
    }

    private func updateButtonTitle() {
        let title = isConnected ? "Отключить VPN" : "Подключить VPN"
        vpnButton.setTitle(title, for: .normal)
    }

    private func loadVPNPreferences() {
        vpnManager.loadFromPreferences { error in
            if let error = error {
                print("Failed to load VPN preferences: \(error)")
            } else {
                print("VPN preferences loaded")
            }
        }
    }

    private func startVPN() {
        do {
            try vpnManager.connection.startVPNTunnel()
            print("VPN Started")
        } catch {
            print("Failed to start VPN: \(error)")
        }
    }

    private func stopVPN() {
        vpnManager.connection.stopVPNTunnel()
        print("VPN Stopped")
    }
}
