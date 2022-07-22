local fr = {
    error = {
      error = 'Erreur, veuillez contacter le support',
      error_cid = 'Erreur, le CID n\'est pas reconnu',
      market_no_money = 'Le marchand n\'a pas d\'argent sur son étal!',
      player_no_money = 'Il vous manque de l\'argent',
    },

    success = {
      robreward = 'Vous avez récupéré $',
      newname = 'Nouveau nom',
      transfert_t = 'Transfert',
      transfert = 'Etal donné à',
      buy_t = 'Achat',
      buy = 'Vous avez acheté l\'étal',
      refill = 'Vous avez déposé',
      buy_prod = 'Achat de',
    },

    menu = {
      market = 'Étal',
      quit = "Quitter",
      return_m = "Retour",
      buy = 'Acheter l\'étal',
      buy_sub = "Prix d'achat",
      open_market = 'Acceder à l\'étal',
      open_market_sub = 'Achat d\'articles en tous genres',
      rob = 'Braquer l\'étal',
      rob_sub = 'À vos risques et périls',
      refill = 'Réaprovisionner l\'étal',
      refill_sub = 'Mettez vos articles sur l\'étal',
      refill_in = 'Voici la liste des produits disponible à la vente!',
      checkmoney = 'Voir la caisse',
      checkmoney_sub = 'Vérifier / Récuperer le solde',
      manage = 'Gestion de l\'étal',
      manage_sub = 'Gérer le nom, Donner l\'étal, Récupérer des articles',
      market_sub = 'Voici la liste des produits, le stock ainsi que le prix unitaire',
      instock = 'En stock',
      price = 'Prix unitaire',
      no_item = 'Aucun produit',
      no_item_sub = 'Vous n\'avez pas de produits à mettre sur l\'étal !',
      in_inv = 'Dans l\'inventaire',
      checkmoney_in = 'Voici votre caisse',
      currentmoney = 'Solde de la caisse',
      withdraw = 'Retirer l\'argent',
      withdraw_sub = 'L\'argent vous sera remis en cash !',
      confirm_buy = 'Valider l\'achat',
      confirm_buy_sub = '(Vous devez avoir l\'argent en cash) !',
      manage_in = 'Gestion de votre étal',
      manage_in_name = 'Changer le nom',
      manage_in_name_sub = 'Un nouveau nom pour votre étal ? !',
      manage_in_give_market = 'Donner l\'étal',
      manage_in_give_market_sub = 'ATTENTION ACTION IREVERSIBLE',
      buy_price = 'Prix',
    },

    input = {
      validate = 'Valider',
      give_market = 'Veuillez indiquer l\'ID Permanent du destinataire (/cid)',
      give_market_champ = '(ATTENTION CASE SENSIBLE)',
      name = 'Nouveau nom de votre étal',
      name_champ = 'Nom de votre étal',
      withdraw = 'Retirer de l\'argent',
      withdraw_champ = 'Montant',
      refill = 'Mettre en vente ',
      refill_price = 'A quel prix ?',
      howmany_buy = 'Combient voulez-vous en acheter ?',
      qt = 'Quantité',
    },

    rob = {
      fail = 'Le marchand prend les armes! Echappez vous!',
      good = 'Braquage en cours..',
      already = 'L\'étal à déja été braqué, revenez plus tard!',
      need_gun = 'Vous devez être armé afin de pouvoir braquer le marchand!',
    },

    other = {
      blips = 'Etal de marché',
      prompt = 'Ouvrir l\'étal',
    },

}

----------------------------------------------------------------------------------------
-- Hello Google Translate

local en = {
  error = {
    error = 'Error, please contact the support',
    error_cid = 'Error, the cid is not recognized',
    market_no_money = 'The merchant has no money on his stall!',
    player_no_money = 'You lack money',
  },

  success = {
    robreward = 'You have recovered $',
    newname = 'New name',
    transfer_t = 'Transfer',
    transfer = 'Stalker given to ',
    buy_t = 'Purchase',
    buy = 'You bought the stall',
    refill = 'You have deposited ',
    buy_prod = 'Purchase of ',
  },

  menu = {
    market = 'Stall',
    quit = "Exit",
    return_m = "Return",
    buy = 'Buy',
    buy_sub = "Purchase price",
    open_market = 'Stall',
    open_market_sub = 'Purchase of items of all kinds',
    rob = 'Stall',
    rob_sub = 'At your peril',
    refill = 'Replenish the stall',
    refill_sub = 'Put your items on the stall',
    refill_in = 'Here isThe list of products available for sale!',
    checkmoney = 'See the cash register',
    checkmoney_sub = 'Check / collect the balance',
    manage = 'Stall management',
    manage_sub = 'Manage the name, give the stall, recover articles',
    market_sub = 'Here isthe list of products, the stock and the unit price',
    instock = 'A log',
    price = 'Unit price: $',
    no_item = 'No product',
    no_item_sub = 'You have no products to put on the stall!',
    in_inv = 'In the inventory',
    checkmoney_in = 'Here is your cashier',
    currentmoney = 'Balance of the cash register',
    withdraw = 'Withdraw money',
    withdraw_sub = 'The money will be given to you in cash !',
    confirm_buy = 'Validate the purchase',
    confirm_buy_sub = '(You must have cash in cash)!',
    manage_in = 'Management of your stall',
    manage_in_name = 'Change the name',
    manage_in_name_sub = 'A new name for your stall?! ',
    manage_in_give_market = 'Give the stall',
    manage_in_give_market_sub = 'Care, irreversible action',
  },

  input  = {
    validate = 'Validate',
    give_market = 'Please indicate the permanent ID of the recipient (/cid)',
    give_market_champ = '(car sensitive box)',
    name = 'New name of your stall',
    name_champ = 'name of your stall',
    withdraw = 'Remove money: (max: $',
    withdraw_champ = 'Amount',
    refill = 'Sale',
    howmany_buy = 'How many do you want to buy it?',
    qt = 'How many ?',
  },

  rob = {
    fail = 'The merchant takes up arms! Escape! ',
    good = 'Robbery in progress ..',
    already = 'The spread was already turned, come back later!',
    need_gun = 'You must be armed in order to be able to spark the merchant!',
  },

}

----------------------------------------------------------------------------------------

Lang = Locale:new({
  phrases = fr,
  warnOnMissing = true
})
