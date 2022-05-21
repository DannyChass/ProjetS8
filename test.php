<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="test.css">
    <title>Mileage2Blockchain</title>
    <script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="node_modules/web3.js-browser/build/web3.min.js"></script>
    <script src="node_modules/bn.js/lib/bn.js"></script>
    <script language="javascript" type="text/javascript" src="abi_message.js"></script>
    <script src="https://unpkg.com/@metamask/detect-provider/dist/detect-provider.min.js"></script>
    <script language="javascript" type="text/javascript" src="metamask.min.js"></script>
</head>
<body>
    <h1 style="text-align:center">Mileage2Blockchain</h1>
    <button id="togg1">View Mileage Data</button>
    <button id="togg2">Register Vehicule</button>
    <button id="togg3">Reset Registration</button>
        <script>
            var mileage;
            
            function startApp() {
                var addressMileage = "0xf39BC2dCB8bCA65365effFe9865B3D5A5C3A9070";
                mileage = new web3js.eth.Contract(mileageABI, addressMileage);
            }

            // Vérifier si web3 a bien été injecté (Mist/MetaMask)
            if (typeof web3 !== 'undefined') {
            // Si oui, on peut utiliser l'injection
                //web3js = new Web3(web3.currentProvider);
                web3js = new Web3(window.ethereum);
                window.ethereum.enable();
                console.log("You are connected to MetaMask");
            } else {
                console.log("Erreur");
                // si non, on peut ajouter ici un code qui invite à télécharger l'extension
            }

            // on peut démarrer l'utilisation de l'application
            startApp()

        </script>
            
    <div class="d1" id="d1">
        <p>
            <a>Véhicle Identification Number</a>
            <input type="text" id="VIN">
        </p>
        <p>
        <button id="test" onClick="showData()">Show Data</button>
        </p>
        <div id="data">

        </div>
        <script>
            let accounts = document.getElementById('accounts');

            const init = async() => {
                let web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));
                web3.eth.getAccounts().then(function(allAccounts){
                    for (let i = 0 ; i < allAccounts.length ; i++) {
                        accounts.innerHTML += allAccounts[i]+'<br />';
                    }
                })
            }

            function hashing(vin) {
                return mileage.methods.getSha256(vin).call();
            }

            function show(vin) {
                return mileage.methods.mappedVinToKeyEntries(vin).call();
            }

            function count(hashvin) {
                return mileage.methods.countEntriesOfAdress(hashvin).call();
            }

            function getKm(vin,index) {
                return mileage.methods.getValueKM(vin,index).call();
            }

            function getTime(vin,index) {
                return mileage.methods.getValueTime(vin,index).call();
            }

            function convert(test) {
                return mileage.methods.st2num(test).call();
            }

            async function showData() {
                var input = document.getElementById("VIN").value;
                await hashing(input)
                hashing(input)
                .then((result) => {
                    show(result)
                    .then((val) => {
                        if (val == 0x0000000000000000000000000000000000000000) {
                            alert("Data unavailable")
                        }
                        else {
                            count(result)
                            .then((val2) => {
                                for (i=0;i<val2;i++) {
                                    console.log("test")
                                    var a = i.toString();
                                    console.log("a " +typeof(a))
                                    convert(a)
                                    .then((valconvert) => {
                                        getTime(result,a)
                                        .then((Time) => {
                                            const milli = Time*1000;
                                            const date = new Date(milli);
                                            const day = date.toLocaleString("en-US", {day: "numeric"});
                                            const month = date.toLocaleString("en-US", {month: "long"});
                                            const year = date.toLocaleString("en-US", {year: "numeric"});
                                            var cleandate = day +" "+ month +" "+ year + " "
                                            data.innerHTML += cleandate
                                        })
                                            getKm(result,a)
                                            .then((Km) => {
                                                data.innerHTML += Km +"m"+'<br />' ;
                                        })
                                        
                                    })
                                }
                            })
                        }
                    })
                })
            }
            
        </script>
    </div>
        
    <div id="d2">
        <p>
            <a>Véhicle Identification Number</a>
            <input type="text" id="VINmap">
        </p>
        <p>
            <a>Véhicle Public Key</a>
            <input type="text" id="PKeymap">
        </p>
        <p>
            <button id="bouton2" onClick="associer()">Set Mapping</button>
        </p>
        <script>

            function hashing(vin) {
                return mileage.methods.getSha256(vin).call();
            }

            async function getCurrentAccount() {
                const accounts = await window.web3.eth.getAccounts();
                return accounts[0];
            }

            async function associer() {
                var hash;
                var input = document.getElementById("VINmap").value;
                var key = document.getElementById("PKeymap").value;
                console.log(input);
                console.log(key);
                await hashing(input);
                const account = await getCurrentAccount();
                hashing(input)
                    .then((result) => {
                    if(key != account) {
                        alert("You are not connected to the right account!");
                    }
                    else {
                        return mileage.methods.mapVinToPublicKey(result,key).send({from : account}); 
                    }
                })
            }

            function truc() {
                var value;
                const compte = getCurrentAccount();
                compte.then((value) => {
                return value;
                });
            }
        </script>
    </div>
    <div id="d3">
        <p>
            <a>Véhicle Identification Number</a>
            <input type="text" id="VINdemap">
        </p>
        <p>
            <a>Véhicle Public Key</a>
            <input type="text" id="PKeydemap">
        </p>
        <p>
            <button id="bouton3" onClick="dissocier()">Reset Mapping</button>
        </p>
    </div>
    <script>
       function hashing(vin) {
                return mileage.methods.getSha256(vin).call();
            }

            async function getCurrentAccount() {
                const accounts = await window.web3.eth.getAccounts();
                return accounts[0];
            }

            async function dissocier() {
                var hash;
                var input = document.getElementById("VINdemap").value;
                var key = document.getElementById("PKeydemap").value;
                await hashing(input);
                const account = await getCurrentAccount();
                hashing(input)
                    .then((result) => {
                    if(key != account) {
                        alert("You are not connected to the right account!");
                    }
                    else {
                        mileage.methods.MileageSender().send({from : account});
                        return mileage.methods.resetVinMapping(result).send({from : account}); 
                    }
                })
            }     
    </script>
</body>
<script type="text/javascript" src=test.js> </script>
</html>
