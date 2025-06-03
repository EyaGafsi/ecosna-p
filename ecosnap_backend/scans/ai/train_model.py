import os
import torch
from torchvision import datasets, transforms, models
from torch import nn, optim
from torch.utils.data import DataLoader

# Paramètres
data_dir = "data/Garbage classification"
model_path = "ai/recycling_classifier.pt"
classes_path = "ai/classes.txt"
batch_size = 32
epochs = 5
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Prétraitement
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor()
])

# Dataset
train_data = datasets.ImageFolder(os.path.join(data_dir, "train"), transform=transform)
train_loader = DataLoader(train_data, batch_size=batch_size, shuffle=True)

# Modèle
model = models.resnet18(pretrained=True)
model.fc = nn.Linear(model.fc.in_features, len(train_data.classes))
model = model.to(device)

# Entraînement
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

print("Démarrage de l'entraînement...")
for epoch in range(epochs):
    model.train()
    running_loss = 0.0
    for inputs, labels in train_loader:
        inputs, labels = inputs.to(device), labels.to(device)

        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        running_loss += loss.item()

    print(f"Époque {epoch + 1}/{epochs}, Perte: {running_loss / len(train_loader)}")

# Sauvegarde
os.makedirs("ai", exist_ok=True)
torch.save(model.state_dict(), model_path)
with open(classes_path, "w") as f:
    f.write("\n".join(train_data.classes))

print("Modèle sauvegardé !")
