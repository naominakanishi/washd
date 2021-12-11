//
//  SceneDelegate.swift
//  washd
//
//  Created by Naomi Nakanishi on 02/10/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = UINavigationController(rootViewController: ClothingDetailViewController(
            clothing: Clothing(
                name: "Blusa branca",
                type: .top,
                color: .white,
                nfcTagId: nil,
                washingTags: [.init(imageNames: ["2-do-not-bleach", "do-not-dry"], name: "Não lava", category: .bleaching)],
                description: "A Camisa Ladrilho é confeccionada pela CALMA em 100% viscolinho, um tipo de tecido misto, com linho, viscose e algodão com uma textura fina e bem leve de manusear.Sua produção passou por um processo minucioso e manual dentro do nosso ateliê: Desde a criação de novos modelos até as últimas costurinhas. Cada etapa da produção é feita no Brasil com produtos de qualidade escolhidos à dedos com carinho e alma.Aqui na CALMA acreditamos na importância de amar e valorizar cada peça de nosso guarda-roupa, entendendo o processo de como a roupa foi pensada, confeccionada e finalizada para chegar até você. Ou seja, além de fazer bem pro visual, faz bem pro coração.")))
        window.backgroundColor = .washdColors.background
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

