<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Парикмахерская</title>
    <link rel="stylesheet" href="<?= SITE_URL ?>css/styles.css">
</head>
<body>
    <div class="container">
        <h1>Список мастеров</h1>

        <?php
        $flash = getFlash();
        if ($flash): ?>
            <div class="alert <?= html($flash["type"]) ?>"><?= html($flash["message"]) ?></div>
        <?php endif; ?>

        <?php if ($action === "create" || $action === "edit"): ?>
            <h2><?= $action === "edit" ? "Редактировать мастера" : "Добавить мастера" ?></h2>
            <form action="index.php?action=<?= $action . (isset($master["id"]) ? "&id=" . $master["id"] : "") ?>" method="post" class="form">
                <div class="form-group">
                    <label for="full_name">Имя Фамилия:</label>
                    <input type="text" id="full_name" name="full_name" value="<?= html($master["full_name"] ?? "") ?>" required>
                </div>
                <div class="form-group">
                    <label for="phone">Телефон:</label>
                    <input type="tel" id="phone" name="phone" value="<?= html($master["phone"] ?? "") ?>">
                </div>
                <div class="form-group">
                    <label for="specialization">Специализация:</label>
                    <select id="specialization" name="specialization" required>
                        <option value="MALE" <?= ($master["specialization"] ?? "") === "MALE" ? "selected" : "" ?>>Мужской</option>
                        <option value="FEMALE" <?= ($master["specialization"] ?? "") === "FEMALE" ? "selected" : "" ?>>Женский</option>
                        <option value="UNIVERSAL" <?= ($master["specialization"] ?? "") === "UNIVERSAL" ? "selected" : "" ?>>Универсал</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="commission_percent">Комиссия (%):</label>
                    <input type="number" id="commission_percent" name="commission_percent" value="<?= html(($master["commission_percent"] ?? 0) * 100) ?>" min="0" max="100" step="1" required>
                </div>
                <div class="form-group">
                    <label for="is_active">Статус:</label>
                    <select id="is_active" name="is_active" required>
                        <option value="1" <?= ($master["is_active"] ?? 1) == 1 ? "selected" : "" ?>>Активен</option>
                        <option value="0" <?= ($master["is_active"] ?? 1) == 0 ? "selected" : "" ?>>Уволен</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn save">Сохранить</button>
                    <a href="index.php" class="btn cancel">Отмена</a>
                </div>
            </form>
        <?php elseif ($action === "delete" && isset($master)): ?>
            <div class="confirmation">
                <h2>Удалить мастера</h2>
                <p>Вы уверены, что хотите удалить мастера "<?= html($master["full_name"]) ?>"?</p>
                <p>Это действие невозможно отменить.</p>
                <form action="index.php?action=delete&id=<?= $master["id"] ?>" method="post" class="confirmation-actions">
                    <button type="submit" name="confirm" value="1" class="btn delete">Удалить</button>
                    <a href="index.php" class="btn cancel">Отмена</a>
                </form>
            </div>
        <?php endif; ?>

        <?php if (!empty($masters)): ?>
            <table>
                <thead>
                    <tr>
                        <th>Имя</th>
                        <th>Телефон</th>
                        <th>Специализация</th>
                        <th>Комиссия (%)</th>
                        <th>Статус</th>
                        <th>Действия</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($masters as $master): ?>
                        <tr class="<?= ($master["is_active"] ?? 1) == 0 ? 'inactive' : '' ?>">
                            <td><?= html($master["full_name"]) ?></td>
                            <td><?= html($master["phone"] ?? "-") ?></td>
                            <td><?= html(formatSpecialization($master["specialization"])) ?></td>
                            <td><?= html(number_format($master["commission_percent"] * 100, 1)) ?>%</td>
                            <td>
                                <?php if (($master["is_active"] ?? 1) == 0): ?>
                                    <span class="status-badge inactive-badge">Уволен</span>
                                <?php else: ?>
                                    <span class="status-badge active-badge">Активен</span>
                                <?php endif; ?>
                            </td>
                            <td class="actions">
                                <a href="index.php?action=edit&id=<?= $master["id"] ?>" class="btn edit">Редактировать</a>
                                <a href="index.php?action=delete&id=<?= $master["id"] ?>" class="btn delete">Удалить</a>
                                <a href="index.php?action=schedule&master_id=<?= $master["id"] ?>" class="btn edit">График</a>
                                <a href="index.php?action=services&master_id=<?= $master["id"] ?>" class="btn add">Выполненные работы</a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <p class="no-data">Нет мастеров для отображения.</p>
        <?php endif; ?>

        <div class="add-button-container">
            <a href="index.php?action=create" class="button">Добавить мастера</a>
        </div>
    </div>
</body>
</html>
