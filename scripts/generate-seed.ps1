# Genere data/seed-pharmacies.json — 18 pharmacies, 45+ produits chacune
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$out = Join-Path $root "data\seed-pharmacies.json"

$pharmacyImages = @(
  "https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1471864190281-a93a3070bfe6?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=600&h=360&fit=crop&sat=-20",
  "https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=600&h=360&fit=crop&bright=10",
  "https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=600&h=360&fit=crop&hue=20",
  "https://images.unsplash.com/photo-1584308664744-24d5c474f2ae?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1550572017-eddffbd3d990?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1584017911766-d451b3d0e843?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=600&h=360&fit=crop",
  "https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=600&h=360&fit=crop&contrast=10",
  "https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=600&h=360&fit=crop&sat=30",
  "https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=600&h=360&fit=crop&bright=-5",
  "https://images.unsplash.com/photo-1471864190281-a93a3070bfe6?w=600&h=360&fit=crop&sat=10",
  "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=600&h=360&fit=crop&hue=-10"
)

$productImages = @(
  "https://images.unsplash.com/photo-1584308664744-24d5c474f2ae?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1550572017-eddffbd3d990?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1584017911766-d451b3d0e843?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1471864190281-a93a3070bfe6?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1576602976037-1748c7b0a4e8?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=160&h=160&fit=crop",
  "https://images.unsplash.com/photo-1584308664744-24d5c474f2ae?w=160&h=160&fit=crop&sat=-30",
  "https://images.unsplash.com/photo-1631549916768-4119b2e5f6b6?w=160&h=160&fit=crop&bright=5",
  "https://images.unsplash.com/photo-1550572017-eddffbd3d990?w=160&h=160&fit=crop&hue=15",
  "https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=160&h=160&fit=crop&contrast=8",
  "https://images.unsplash.com/photo-1584017911766-d451b3d0e843?w=160&h=160&fit=crop&sat=20"
)

$productCatalog = @(
  @{ name = "Paracétamol 500mg boîte 20"; cat = "Antalgique"; base = 1500 },
  @{ name = "Doliprane 1000mg"; cat = "Antalgique"; base = 2200 },
  @{ name = "Ibuprofène 400mg"; cat = "Antalgique"; base = 2000 },
  @{ name = "Aspirine 100mg"; cat = "Antalgique"; base = 1200 },
  @{ name = "Spasfon comprimés"; cat = "Antalgique"; base = 3500 },
  @{ name = "Amoxicilline 500mg"; cat = "Antibiotique"; base = 5500 },
  @{ name = "Azithromycine 250mg"; cat = "Antibiotique"; base = 8900 },
  @{ name = "Ciprofloxacine 500mg"; cat = "Antibiotique"; base = 7200 },
  @{ name = "Métronidazole 250mg"; cat = "Antibiotique"; base = 4100 },
  @{ name = "Sérum physiologique 500ml"; cat = "Soins"; base = 2500 },
  @{ name = "Bétadine solution"; cat = "Soins"; base = 2900 },
  @{ name = "Pansements stériles x10"; cat = "Premiers soins"; base = 1800 },
  @{ name = "Compresses stériles"; cat = "Premiers soins"; base = 2200 },
  @{ name = "Eau oxygénée 100ml"; cat = "Premiers soins"; base = 1100 },
  @{ name = "Thermomètre digital"; cat = "Matériel"; base = 12000 },
  @{ name = "Tensiomètre brassard"; cat = "Matériel"; base = 45000 },
  @{ name = "Gants latex boîte 100"; cat = "Matériel"; base = 4500 },
  @{ name = "Masques chirurgicaux x50"; cat = "Protection"; base = 3500 },
  @{ name = "Gel hydroalcoolique 500ml"; cat = "Hygiène"; base = 2800 },
  @{ name = "Savon antiseptique"; cat = "Hygiène"; base = 1900 },
  @{ name = "Vitamine C 1000mg"; cat = "Complément"; base = 4500 },
  @{ name = "Multivitamines adulte"; cat = "Complément"; base = 7200 },
  @{ name = "Fer + acide folique"; cat = "Complément"; base = 6500 },
  @{ name = "Oméprazole 20mg"; cat = "Digestif"; base = 3200 },
  @{ name = "Smecta sachets"; cat = "Digestif"; base = 4800 },
  @{ name = "Loperamide 2mg"; cat = "Digestif"; base = 2600 },
  @{ name = "Sirop toux adulte"; cat = "ORL"; base = 4200 },
  @{ name = "Spray nasal décongestionnant"; cat = "ORL"; base = 3800 },
  @{ name = "Pastilles gorge"; cat = "ORL"; base = 2400 },
  @{ name = "Sirop paracétamol enfant"; cat = "Pédiatrie"; base = 2600 },
  @{ name = "Lait infantile 1er âge"; cat = "Pédiatrie"; base = 14500 },
  @{ name = "Couches taille 3 (paquet)"; cat = "Puériculture"; base = 9800 },
  @{ name = "Crème solaire SPF50"; cat = "Dermato"; base = 8500 },
  @{ name = "Crème hydratante visage"; cat = "Dermato"; base = 5200 },
  @{ name = "Crème anti-moustiques"; cat = "Protection"; base = 3900 },
  @{ name = "Antipaludéen comprimés"; cat = "Spécialité"; base = 4200 },
  @{ name = "Réhydratation ORS sachets"; cat = "Urgence"; base = 1500 },
  @{ name = "Test grossesse"; cat = "Diagnostic"; base = 3500 },
  @{ name = "Bande élastique 10cm"; cat = "Matériel"; base = 2200 },
  @{ name = "Collyre larmes artificielles"; cat = "Ophtalmo"; base = 4100 },
  @{ name = "Anti-nauséeux"; cat = "Voyage"; base = 3400 },
  @{ name = "Trousse premiers secours"; cat = "Kit"; base = 15000 },
  @{ name = "Actifed rhume"; cat = "ORL"; base = 5100 },
  @{ name = "Ventoline spray"; cat = "Respiratoire"; base = 18500 },
  @{ name = "Insuline stylo (sur ordonnance)"; cat = "Diabète"; base = 35000 },
  @{ name = "Antiseptique main 100ml"; cat = "Hygiène"; base = 2100 },
  @{ name = "Probiotiques flore intestinale"; cat = "Digestif"; base = 8900 },
  @{ name = "Huile d'arachide médicale 60ml"; cat = "Soins"; base = 1800 },
  @{ name = "Poudre de piroxicam"; cat = "Antalgique"; base = 3300 },
  @{ name = "Cotrimoxazole forte"; cat = "Antibiotique"; base = 3800 },
  @{ name = "Sérum antirabique (réserve)"; cat = "Urgence"; base = 25000 }
)

$pharmaciesMeta = @(
  @{ id = "ph-001"; name = "Pharmacie de la Poste"; arr = "1er Arrondissement"; q = "Centre-ville"; phone = "+242 06 512 34 01"; hours = "Lun-Sam 8h-20h | Dim 9h-13h"; duty = $true },
  @{ id = "ph-002"; name = "Pharmacie Mavré"; arr = "2e Arrondissement"; q = "Tié-Tié"; phone = "+242 06 523 45 12"; hours = "Lun-Sam 7h30-21h"; duty = $true },
  @{ id = "ph-003"; name = "Pharmacie de la Frontière"; arr = "3e Arrondissement"; q = "Mpaka"; phone = "+242 06 534 56 23"; hours = "Lun-Dim 8h-22h"; duty = $false },
  @{ id = "ph-004"; name = "Pharmacie du Port"; arr = "1er Arrondissement"; q = "Port de Pointe-Noire"; phone = "+242 06 545 67 34"; hours = "Lun-Sam 8h-19h"; duty = $false },
  @{ id = "ph-005"; name = "Pharmacie Loandjili"; arr = "4e Arrondissement"; q = "Loandjili"; phone = "+242 06 556 78 45"; hours = "Lun-Sam 7h-20h | Dim fermé"; duty = $true },
  @{ id = "ph-006"; name = "Pharmacie Ngoyo"; arr = "5e Arrondissement"; q = "Ngoyo"; phone = "+242 06 567 89 56"; hours = "Lun-Sam 8h-21h"; duty = $false },
  @{ id = "ph-007"; name = "Pharmacie Mvou-Mvou"; arr = "2e Arrondissement"; q = "Mvou-Mvou"; phone = "+242 06 578 90 67"; hours = "Lun-Sam 8h-20h"; duty = $false },
  @{ id = "ph-008"; name = "Pharmacie Tié-Tié Plaza"; arr = "2e Arrondissement"; q = "Tié-Tié"; phone = "+242 06 589 01 78"; hours = "Lun-Dim 7h30-22h"; duty = $true },
  @{ id = "ph-009"; name = "Pharmacie Lumumba"; arr = "1er Arrondissement"; q = "Avenue Lumumba"; phone = "+242 06 590 12 89"; hours = "Lun-Sam 8h-19h30"; duty = $false },
  @{ id = "ph-010"; name = "Pharmacie Songolo"; arr = "3e Arrondissement"; q = "Songolo"; phone = "+242 06 601 23 90"; hours = "Lun-Sam 7h30-20h30"; duty = $false },
  @{ id = "ph-011"; name = "Pharmacie Tchimbamba"; arr = "4e Arrondissement"; q = "Tchimbamba"; phone = "+242 06 612 34 01"; hours = "Lun-Sam 8h-20h"; duty = $true },
  @{ id = "ph-012"; name = "Pharmacie Vindoulou"; arr = "5e Arrondissement"; q = "Vindoulou"; phone = "+242 06 623 45 12"; hours = "Lun-Sam 8h-21h"; duty = $false },
  @{ id = "ph-013"; name = "Pharmacie Diosso"; arr = "3e Arrondissement"; q = "Diosso"; phone = "+242 06 634 56 23"; hours = "Lun-Sam 7h-19h"; duty = $false },
  @{ id = "ph-014"; name = "Pharmacie La Base"; arr = "1er Arrondissement"; q = "La Base"; phone = "+242 06 645 67 34"; hours = "Lun-Dim 8h-22h"; duty = $true },
  @{ id = "ph-015"; name = "Pharmacie Grand Marché"; arr = "1er Arrondissement"; q = "Grand Marché"; phone = "+242 06 656 78 45"; hours = "Lun-Sam 7h30-21h"; duty = $false },
  @{ id = "ph-016"; name = "Pharmacie Cité Marine"; arr = "4e Arrondissement"; q = "Cité Marine"; phone = "+242 06 667 89 56"; hours = "Lun-Sam 8h-20h"; duty = $false },
  @{ id = "ph-017"; name = "Pharmacie Km4"; arr = "5e Arrondissement"; q = "Km4"; phone = "+242 06 678 90 67"; hours = "Lun-Sam 8h-19h30"; duty = $true },
  @{ id = "ph-018"; name = "Pharmacie Aeroport"; arr = "5e Arrondissement"; q = "Zone Aéroport"; phone = "+242 06 689 01 78"; hours = "Lun-Dim 6h-23h"; duty = $false }
)

function Get-ProductsForPharmacy([int]$idx) {
  $products = @()
  $count = 45
  for ($i = 0; $i -lt $count; $i++) {
    $item = $productCatalog[($i + $idx) % $productCatalog.Count]
    $priceOffset = ($idx * 37 + $i * 13) % 500
    $price = $item.base + $priceOffset
    $imgIdx = ($i + $idx * 3) % $productImages.Count
    $inStock = (($i + $idx) % 7) -ne 0
    $products += @{
      name = $item.name
      price_fcfa = $price
      category = $item.cat
      image_url = $productImages[$imgIdx]
      in_stock = $inStock
    }
  }
  return $products
}

$result = @{ pharmacies = @() }
for ($p = 0; $p -lt $pharmaciesMeta.Count; $p++) {
  $m = $pharmaciesMeta[$p]
  $result.pharmacies += @{
    id = $m.id
    name = $m.name
    arrondissement = $m.arr
    quartier = $m.q
    phone = $m.phone
    hours = $m.hours
    is_on_duty = $m.duty
    image_url = $pharmacyImages[$p % $pharmacyImages.Count]
    products = Get-ProductsForPharmacy $p
  }
}

$json = $result | ConvertTo-Json -Depth 6 -Compress:$false
[System.IO.File]::WriteAllText($out, $json, [System.Text.UTF8Encoding]::new($false))
$totalProducts = 18 * 45
Write-Host "OK: $out - 18 pharmacies, $totalProducts produits" -ForegroundColor Green
